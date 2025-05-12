require 'rails_helper'

RSpec.describe "User Login", type: :request do
  let(:user) { create(:user) }

  describe "POST /users/sign_in" do
    it "logs in the user with valid credentials" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Scrape a New Web Page")
    end

    it "does not log in the user with invalid credentials" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'wrongpassword'
        }
      }

      expect(response.body).to include("Invalid Email or password")
    end
  end
end
