require 'rails_helper'

RSpec.describe "Authentication and Authorization", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /pages" do
    context "when not authenticated" do
      it "redirects to the login page" do
        get pages_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { login_as_user(user) }
      it "renders the index page" do
        get pages_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Scrape a New Web Page")
      end
    end
  end
end
