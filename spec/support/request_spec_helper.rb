require 'warden/test/helpers'
module RequestSpecHelper
    include Warden::Test::Helpers

    def login_as_user(user)
      Warden.test_mode!
      login_as(user, scope: :user)
    end

    def logout_user
      logout(:user)
    end
end
