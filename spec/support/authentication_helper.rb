# frozen_string_literal: true

module AuthenticationHelper
  def authenticate!
    TheCaptain.configure do |config|
      config.api_key         = ENV["CAPTAIN_API_KEY"]
      config.api_url         = ENV["CAPTAIN_URL"]
      config.retry_attempts  = 2
    end
  end

  def self.reset_authentication!
    TheCaptain.configure do |config|
      config.api_key = nil
    end
  end

  def reset_authentication!
    AuthenticationHelper.reset_authentication!
  end
end

RSpec.configure do |config|
  config.include(AuthenticationHelper)
  config.before(:each, manual_auth: false) { |_scenario| AuthenticationHelper.reset_authentication! }
end
