# frozen_string_literal: true

module AuthenticationHelper
  def authenticate!
    TheCaptain.configure do |config|
      config.server_api_token = ENV["CAPTAIN_API_KEY"]
      config.base_url         = ENV["CAPTAIN_URL"]
      config.api_version      = ENV.fetch("CAPTAIN_VERSION", "v2")
      config.retry_attempts   = 2
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
