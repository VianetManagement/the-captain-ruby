# frozen_string_literal: true

module AuthenticationHelper
  def self.reset_configurations!
    TheCaptain.reset_configurations!
  end

  def self.reset_authentication!
    TheCaptain.configure do |config|
      config.api_key = "my-extra-secret-key"
    end
  end

  def reset_authentication!
    AuthenticationHelper.reset_authentication!
  end

  def reset_configurations!
    AuthenticationHelper.reset_configurations!
  end
end

RSpec.configure do |config|
  config.include(AuthenticationHelper)
  config.before(:each)             { AuthenticationHelper.reset_configurations! }
  config.before(:each, :auto_auth) { AuthenticationHelper.reset_authentication! }
end
