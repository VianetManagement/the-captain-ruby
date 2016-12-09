module AuthenticationHelper
  def authenticate!
    TheCaptain.configure do |config|
      config.server_api_token = "O5gDlIzw6Hlo1X7O8W1_XQ"
    end
  end

  def self.reset_authentication!
    TheCaptain.configure do |config|
      config.server_api_token = nil
    end
  end

  def reset_authentication!
    AuthenticationHelper.reset_authentication!
  end
end

RSpec.configure do |config|
  config.include(AuthenticationHelper)
  config.before(:each) { |_scenario| AuthenticationHelper.reset_authentication! }
end
