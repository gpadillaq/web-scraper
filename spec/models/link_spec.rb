require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:page) }

  it "is invalid without a URL" do
    link = Link.new(url: nil)
    expect(link).not_to be_valid
  end

  describe "#url_must_be_safe" do
    let(:page) { FactoryBot.create(:page) }

    it "is valid with an HTTP URL" do
      link = Link.new(url: "http://example.com", page: page)
      expect(link).to be_valid
    end

    it "is valid with an HTTPS URL" do
      link = Link.new(url: "https://example.com", page: page)
      expect(link).to be_valid
    end

    it "is invalid with a non-HTTP/HTTPS URL" do
      link = Link.new(url: "ftp://example.com", page: page)
      expect(link).not_to be_valid
      expect(link.errors[:url]).to include("must use HTTP or HTTPS")
    end

    it "is invalid with a malformed URL" do
      link = Link.new(url: "invalid-url", page: page)
      expect(link).not_to be_valid
      expect(link.errors[:url]).to include("must use HTTP or HTTPS")
    end
  end
end
