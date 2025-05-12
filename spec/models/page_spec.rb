require 'rails_helper'

RSpec.describe Page, type: :model do
  it { should have_many(:links).dependent(:destroy) }

  it "is invalid without a URL" do
    page = Page.new(url: nil)
    expect(page).not_to be_valid
  end
end
