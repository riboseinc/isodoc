require "fileutils"

module IsoDoc::WordFunction
  module Postprocess
    # add namespaces for Word fragments
    WORD_NOKOHEAD = <<~HERE.freeze
    <!DOCTYPE html SYSTEM
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml"
xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml">
    <head> <title></title> <meta charset="UTF-8" /> </head>
    <body> </body> </html>
    HERE

    def to_word_xhtml_fragment(xml)
      doc = ::Nokogiri::XML.parse(WORD_NOKOHEAD)
      fragment = doc.fragment(xml)
      fragment
    end

    def table_note_cleanup(docxml)
      super
      # preempt html2doc putting MsoNormal there
      docxml.xpath("//p[not(self::*[@class])]"\
                   "[ancestor::*[@class = 'Note']]").each do |p|
        p["class"] = "Note"
      end
    end

    def postprocess(result, filename, dir)
      header = generate_header(filename, dir)
      result = from_xhtml(cleanup(to_xhtml(result)))
      toWord(result, filename, dir, header)
      @files_to_delete.each { |f| FileUtils.rm_f f }
    end

    def toWord(result, filename, dir, header)
      result = populate_template(result, :word)
      result = from_xhtml(word_cleanup(to_xhtml(result)))
      Html2Doc.process(result, filename: filename, stylesheet: @wordstylesheet,
                       header_file: header, dir: dir,
                       asciimathdelims: [@openmathdelim, @closemathdelim],
                       liststyles: { ul: @ulstyle, ol: @olstyle })
    end

    def word_admonition_images(docxml)
      docxml.xpath("//div[@class = 'Admonition']//img").each do |i|
        i["width"], i["height"] =
          Html2Doc.image_resize(i, File.join(@localdir, i["src"]), @maxheight, 300)
      end
    end

    def word_cleanup(docxml)
      word_preface(docxml)
      word_annex_cleanup(docxml)
      word_table_separator(docxml)
      word_admonition_images(docxml)
      docxml
    end

    EMPTY_PARA = "<p style='margin-top:0cm;margin-right:0cm;"\
      "margin-bottom:0cm;margin-left:0.0pt;margin-bottom:.0001pt;"\
      "line-height:1.0pt;mso-line-height-rule:exactly'>"\
      "<span lang=EN-GB style='display:none;mso-hide:all'>&nbsp;</span></p>"

    def word_table_separator(docxml)
      docxml.xpath("//table").each do |t|
        next unless t&.next_element&.name == "table"
        t.add_next_sibling(EMPTY_PARA)
      end
    end

    # force Annex h2 to be p.h2Annex, so it is not picked up by ToC
    def word_annex_cleanup(docxml)
      docxml.xpath("//h2[ancestor::*[@class = 'Section3']]").each do |h2|
        h2.name = "p"
        h2["class"] = "h2Annex"
      end
    end

    def word_preface(docxml)
      word_cover(docxml) if @wordcoverpage
      word_intro(docxml) if @wordintropage
    end

    def word_cover(docxml)
      cover = File.read(@wordcoverpage, encoding: "UTF-8")
      cover = populate_template(cover, :word)
      coverxml = to_word_xhtml_fragment(cover)
      docxml.at('//div[@class="WordSection1"]').children.first.previous =
        coverxml.to_xml(encoding: "US-ASCII")
    end

    def word_intro(docxml)
      intro = File.read(@wordintropage, encoding: "UTF-8").
        sub(/WORDTOC/, make_WordToC(docxml))
      intro = populate_template(intro, :word)
      introxml = to_word_xhtml_fragment(intro)
      docxml.at('//div[@class="WordSection2"]').children.first.previous =
        introxml.to_xml(encoding: "US-ASCII")
    end

    def generate_header(filename, _dir)
      return nil unless @header
      template = IsoDoc::Common.liquid(File.read(@header, encoding: "UTF-8"))
      meta = @meta.get
      meta[:filename] = filename
      params = meta.map { |k, v| [k.to_s, v] }.to_h
      headerfile = "header.html"
      File.open(headerfile, "w:UTF-8") { |f| f.write(template.render(params)) }
      @files_to_delete << headerfile
      headerfile
    end

    def word_toc_entry(toclevel, heading)
      bookmark = Random.rand(1000000000)
      <<~TOC
        <p class="MsoToc#{toclevel}"><span class="MsoHyperlink"><span
        lang="EN-GB" style='mso-no-proof:yes'>
        <a href="#_Toc#{bookmark}">#{heading}<span lang="EN-GB"
        class="MsoTocTextSpan">
        <span style='mso-tab-count:1 dotted'>. </span>
        </span><span lang="EN-GB" class="MsoTocTextSpan">
        <span style='mso-element:field-begin'></span></span>
        <span lang="EN-GB"
        class="MsoTocTextSpan"> PAGEREF _Toc#{bookmark} \\h </span>
          <span lang="EN-GB" class="MsoTocTextSpan"><span
          style='mso-element:field-separator'></span></span><span
          lang="EN-GB" class="MsoTocTextSpan">1</span>
          <span lang="EN-GB"
          class="MsoTocTextSpan"></span><span
          lang="EN-GB" class="MsoTocTextSpan"><span
          style='mso-element:field-end'></span></span></a></span></span></p>

      TOC
    end

    WORD_TOC_PREFACE1 = <<~TOC.freeze
      <span lang="EN-GB"><span
        style='mso-element:field-begin'></span><span
        style='mso-spacerun:yes'>&#xA0;</span>TOC
        \\o &quot;1-2&quot; \\h \\z \\u <span
        style='mso-element:field-separator'></span></span>
    TOC

    WORD_TOC_SUFFIX1 = <<~TOC.freeze
      <p class="MsoToc1"><span lang="EN-GB"><span
        style='mso-element:field-end'></span></span><span
        lang="EN-GB"><o:p>&nbsp;</o:p></span></p>
    TOC

    def make_WordToC(docxml)
      toc = ""
      docxml.xpath("//h1 | //h2[not(ancestor::*[@class = 'Section3'])]").
        each do |h|
        toc += word_toc_entry(h.name == "h1" ? 1 : 2, header_strip(h))
      end
      toc.sub(/(<p class="MsoToc1">)/,
              %{\\1#{WORD_TOC_PREFACE1}}) +  WORD_TOC_SUFFIX1
    end
  end
end
