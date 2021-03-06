require "spec_helper"

RSpec.describe IsoDoc do
  it "test empty pdf_options" do
    convert = IsoDoc::XslfoPdfConvert.new(
      {
        datauriimage: false,
      }
    )

    expect(convert.pdf_options(nil)).to eq("")
  end

  it "test empty pdf_options for nil font_manifest_file" do
    convert = IsoDoc::XslfoPdfConvert.new(
      {
        datauriimage: false,
        IsoDoc::XslfoPdfConvert::MN2PDF_OPTIONS => {
          IsoDoc::XslfoPdfConvert::MN2PDF_FONT_MANIFEST => nil,
        },
      }
    )

    expect(convert.pdf_options(nil)).to eq("")
  end

  it "test --font-manifest pdf_options" do
    convert = IsoDoc::XslfoPdfConvert.new(
      {
        datauriimage: false,
        IsoDoc::XslfoPdfConvert::MN2PDF_OPTIONS => {
          IsoDoc::XslfoPdfConvert::MN2PDF_FONT_MANIFEST => "/tmp/manifest.yml",
        },
      }
    )

    expect(convert.pdf_options(nil)).to eq("--font-manifest /tmp/manifest.yml")
  end
end
