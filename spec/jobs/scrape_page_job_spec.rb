require 'rails_helper'

RSpec.describe ScrapePageJob, type: :job do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:page) { Page.create!(url: 'https://example.com') }

  before do
    stub_request(:get, page.url).to_return(
      status: 200,
      body: "<html><title>Example</title><a href='https://link.com'>Link</a></html>",
      headers: { 'Content-Type' => 'text/html' }
    )
  end

  it "scrapes the page and creates links" do
    expect {
      ScrapePageJob.perform_now(page.id)
    }.to change(Link, :count).by(1)

    expect(page.reload.status).to eq("completed")
    expect(page.title).to eq("Example")
    expect(page.links.first.url).to eq("https://link.com")
    expect(page.links.first.name).to eq("Link")
  end

  it "sets the page title to the URL if the title is not present" do
    stub_request(:get, page.url).to_return(
      status: 200,
      body: "<html><a href='https://link.com'>Link</a></html>",
      headers: { 'Content-Type' => 'text/html' }
    )

    ScrapePageJob.perform_now(page.id)

    expect(page.reload.title).to eq(page.url)
  end

  it "handles invalid links gracefully" do
    stub_request(:get, page.url).to_return(
      status: 200,
      body: "<html><a href='invalid_link'>Invalid</a></html>",
      headers: { 'Content-Type' => 'text/html' }
    )

    expect {
      ScrapePageJob.perform_now(page.id)
    }.not_to change(Link, :count)

    expect(page.reload.status).to eq("completed")
  end
end
