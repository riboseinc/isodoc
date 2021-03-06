require "spec_helper"

RSpec.describe IsoDoc do
  it "processes unordered lists" do
    expect(xmlpp(IsoDoc::HtmlConvert.new({})
      .convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
            <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface><foreword>
            <ul id="_61961034-0fb1-436b-b281-828857a59ddb"  keep-with-next="true" keep-lines-together="true">
          <li>
            <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2">updated normative references;</p>
          </li>
          <li>
            <p id="_60eb765c-1f6c-418a-8016-29efa06bf4f9">deletion of 4.3.</p>
          </li>
        </ul>
        </foreword></preface>
        </iso-standard>
      INPUT
        #{HTML_HDR}
                     <br/>
                     <div>
                       <h1 class="ForewordTitle">Foreword</h1>
                       <ul id="_61961034-0fb1-436b-b281-828857a59ddb" style="page-break-after: avoid;page-break-inside: avoid;">
               <li>
                 <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2">updated normative references;</p>
               </li>
               <li>
                 <p id="_60eb765c-1f6c-418a-8016-29efa06bf4f9">deletion of 4.3.</p>
               </li>
             </ul>
                     </div>
                     <p class="zzSTDTitle1"/>
                   </div>
                 </body>
             </html>
      OUTPUT
  end

  it "processes unordered checklists" do
    expect(xmlpp(IsoDoc::HtmlConvert.new({})
      .convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
            <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface><foreword>
            <ul id="_61961034-0fb1-436b-b281-828857a59ddb">
          <li  checkedcheckbox="true" uncheckedcheckbox="false">
            <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2">updated normative references;</p>
          </li>
          <li checkedcheckbox="false" uncheckedcheckbox="true">
            <p id="_60eb765c-1f6c-418a-8016-29efa06bf4f9">deletion of 4.3.</p>
          </li>
        </ul>
        </foreword></preface>
        </iso-standard>
      INPUT
        #{HTML_HDR}
                     <br/>
           <div>
                     <h1 class='ForewordTitle'>Foreword</h1>
                     <ul id='_61961034-0fb1-436b-b281-828857a59ddb'>
                       <li>
                       <span class='zzMoveToFollowing'>
                         <input type='checkbox'/>
                         </span>
                         <p id='_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2'>updated normative references;</p>
                       </li>
                       <li>
                       <span class='zzMoveToFollowing'>
                         <input type='checkbox'  checked='checked'/>
                         </span>
                         <p id='_60eb765c-1f6c-418a-8016-29efa06bf4f9'>deletion of 4.3.</p>
                       </li>
                     </ul>
                   </div>
                   <p class='zzSTDTitle1'/>
                 </div>
               </body>
             </html>
      OUTPUT
  end

  it "processes unordered checklists (Word)" do
    expect(xmlpp(IsoDoc::WordConvert.new({})
      .convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
            <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface><foreword>
            <ul id="_61961034-0fb1-436b-b281-828857a59ddb">
          <li  checkedcheckbox="true" uncheckedcheckbox="false">
            <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2">updated normative references;</p>
          </li>
          <li checkedcheckbox="false" uncheckedcheckbox="true">
            <p id="_60eb765c-1f6c-418a-8016-29efa06bf4f9">deletion of 4.3.</p>
          </li>
        </ul>
        </foreword></preface>
        </iso-standard>
      INPUT
               <html xmlns:epub="http://www.idpf.org/2007/ops" lang="en">
                  <head><style/></head>
        <body lang='EN-US' link='blue' vlink='#954F72'>
                   <div class='WordSection1'>
                     <p>&#160;</p>
                   </div>
                   <p>
                     <br clear='all' class='section'/>
                   </p>
                   <div class='WordSection2'>
                     <p>
                       <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
                     </p>
                     <div>
                       <h1 class='ForewordTitle'>Foreword</h1>
                       <ul id='_61961034-0fb1-436b-b281-828857a59ddb'>
                         <li>
                           <span class='zzMoveToFollowing'>&#9745; </span>
                           <p id='_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2'>updated normative references;</p>
                         </li>
                         <li>
                         <span class='zzMoveToFollowing'>&#9744; </span>
                           <p id='_60eb765c-1f6c-418a-8016-29efa06bf4f9'>deletion of 4.3.</p>
                         </li>
                       </ul>
                     </div>
                     <p>&#160;</p>
                   </div>
                   <p>
                     <br clear='all' class='section'/>
                   </p>
                   <div class='WordSection3'>
                     <p class='zzSTDTitle1'/>
                   </div>
                 </body>
               </html>
      OUTPUT
  end

  it "processes ordered lists" do
    expect(xmlpp(IsoDoc::HtmlConvert.new({})
      .convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
            <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface><foreword>
            <ol id="_ae34a226-aab4-496d-987b-1aa7b6314026" type="alphabet"  keep-with-next="true" keep-lines-together="true">
          <li>
            <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">all information necessary for the complete identification of the sample;</p>
          </li>
          <ol>
          <li>
            <p id="_8a7b6299-db05-4ff8-9de7-ff019b9017b2">a reference to this document (i.e. ISO 17301-1);</p>
          </li>
          <ol>
          <li>
            <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">the sampling method used;</p>
          </li>
          </ol>
          </ol>
        </ol>
        </foreword></preface>
        </iso-standard>
      INPUT
        #{HTML_HDR}
                     <br/>
                     <div>
                       <h1 class="ForewordTitle">Foreword</h1>
                       <ol type="a" id="_ae34a226-aab4-496d-987b-1aa7b6314026" style="page-break-after: avoid;page-break-inside: avoid;">
               <li>
                 <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">all information necessary for the complete identification of the sample;</p>
               </li>
               <ol type="1">
               <li>
                 <p id="_8a7b6299-db05-4ff8-9de7-ff019b9017b2">a reference to this document (i.e. ISO 17301-1);</p>
               </li>
               <ol type="i">
               <li>
                 <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">the sampling method used;</p>
               </li>
               </ol>
               </ol>
             </ol>
                     </div>
                     <p class="zzSTDTitle1"/>
                   </div>
                 </body>
             </html>
      OUTPUT
  end

  it "processes Roman Upper ordered lists" do
    expect(xmlpp(IsoDoc::HtmlConvert.new({})
      .convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
            <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface><foreword>
            <ol id="_ae34a226-aab4-496d-987b-1aa7b6314026" type="roman_upper">
          <li id="_ae34a226-aab4-496d-987b-1aa7b6314027">
            <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">all information necessary for the complete identification of the sample;</p>
          </li>
          <li>
            <p id="_8a7b6299-db05-4ff8-9de7-ff019b9017b2">a reference to this document (i.e. ISO 17301-1);</p>
          </li>
          <li>
            <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">the sampling method used;</p>
          </li>
        </ol>
        </foreword></preface>
        </iso-standard>
      INPUT
        #{HTML_HDR}
                     <br/>
                     <div>
                       <h1 class="ForewordTitle">Foreword</h1>
                       <ol type="I" id="_ae34a226-aab4-496d-987b-1aa7b6314026">
               <li id="_ae34a226-aab4-496d-987b-1aa7b6314027">
                 <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">all information necessary for the complete identification of the sample;</p>
               </li>
               <li>
                 <p id="_8a7b6299-db05-4ff8-9de7-ff019b9017b2">a reference to this document (i.e. ISO 17301-1);</p>
               </li>
               <li>
                 <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">the sampling method used;</p>
               </li>
             </ol>
                     </div>
                     <p class="zzSTDTitle1"/>
                   </div>
                 </body>
             </html>
      OUTPUT
  end

  it "processes definition lists" do
    expect(xmlpp(IsoDoc::HtmlConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <dl id="_732d3f57-4f88-40bf-9ae9-633891edc395"  keep-with-next="true" keep-lines-together="true">
        <dt>
          W
        </dt>
        <dd>
          <p id="_05d81174-3a41-44af-94d8-c78b8d2e175d">mass fraction of gelatinized kernels, expressed in per cent</p>
        </dd>
        <dt><stem type="AsciiMath">w</stem></dt>
        <dd><p>??</p></dd>
        <note><p>This is a note</p></note>
        </dl>
      </foreword></preface>
      </iso-standard>
    INPUT
      #{HTML_HDR}
                       <br/>
                       <div>
                         <h1 class="ForewordTitle">Foreword</h1>
                         <dl id="_732d3f57-4f88-40bf-9ae9-633891edc395" style="page-break-after: avoid;page-break-inside: avoid;">
                           <dt>
                             <p>
                   W
                 </p>
                           </dt>
                           <dd>
                   <p id="_05d81174-3a41-44af-94d8-c78b8d2e175d">mass fraction of gelatinized kernels, expressed in per cent</p>
                 </dd>
                           <dt>
                             <span class="stem">(#(w)#)</span>
                           </dt>
                           <dd>
                             <p>??</p>
                           </dd>
                         </dl>
                         <div class="Note">
          <p>&#160; This is a note</p>
        </div>
                       </div>
                       <p class="zzSTDTitle1"/>
                     </div>
                   </body>
               </html>
    OUTPUT
  end

  it "processes definition lists (Word)" do
    expect(xmlpp(IsoDoc::WordConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <dl id="_732d3f57-4f88-40bf-9ae9-633891edc395">
        <dt>
          W
        </dt>
        <dd>
          <p id="_05d81174-3a41-44af-94d8-c78b8d2e175d">mass fraction of gelatinized kernels, expressed in per cent</p>
        </dd>
        <dt><stem type="AsciiMath">w</stem></dt>
        <dd><p>??</p></dd>
        <note><p>This is a note</p></note>
        </dl>
      </foreword></preface>
      </iso-standard>
    INPUT
         <html xmlns:epub="http://www.idpf.org/2007/ops" lang="en">
        <head><style/></head>
          <body lang="EN-US" link="blue" vlink="#954F72">
            <div class="WordSection1">
              <p>&#160;</p>
            </div>
            <p><br clear="all" class="section"/></p>
            <div class="WordSection2">
              <p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
              <div>
                <h1 class="ForewordTitle">Foreword</h1>
                <table class="dl">
                  <tr>
                    <td valign="top" align="left">
                      <p align="left" style="margin-left:0pt;text-align:left;">
          W
        </p>
                    </td>
                    <td valign="top">
          <p id="_05d81174-3a41-44af-94d8-c78b8d2e175d">mass fraction of gelatinized kernels, expressed in per cent</p>
        </td>
                  </tr>
                  <tr>
                    <td valign="top" align="left">
                    <p align="left" style="margin-left:0pt;text-align:left;">
                      <span class="stem">(#(w)#)</span>
                    </p>
                    </td>
                    <td valign="top">
                      <p>??</p>
                    </td>
                  </tr>
                  <tr>
                   <td colspan="2">
                     <div class="Note">
                       <p class="Note"><span class="note_label"/><span style="mso-tab-count:1">&#160; </span>This is a note</p>
                     </div>
                    </td>
                  </tr>
                </table>
              </div>
              <p>&#160;</p>
            </div>
            <p><br clear="all" class="section"/></p>
            <div class="WordSection3">
              <p class="zzSTDTitle1"/>
            </div>
          </body>
      </html>
    OUTPUT
  end
end
