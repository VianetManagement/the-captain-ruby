module AuthenticationHelper
  def authenticate!
    TheCaptain.configure do |config|
      config.server_api_token = "qznc1NGHZqy5Sh9CN9p2mTS6ne19IqgXIq81dRNe1LTLplSpeHJEVREUpnIX5HIh"
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
