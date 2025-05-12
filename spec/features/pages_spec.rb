require 'rails_helper'

RSpec.describe "Pages", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  before { login_as_user(user) }
  after { logout_user }

  describe "GET /index" do
    it "renders the index template" do
      get pages_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Scrape a New Web Page")
    end
  end

  describe "POST /pages" do
    it "creates a new page and enqueues the job" do
      expect {
        post pages_path, params: { page: { url: "https://example.com" } }
      }.to change(Page, :count).by(1)
    end
  end
end
