# frozen_string_literal: true

require "dotenv/load"
require "the_captain"
require "faker"
require "pp"

Dotenv.load!("../development.env")

TheCaptain.configure do |config|
  config.server_api_token = ENV["CAPTAIN_API_KEY"]
  config.base_url         = ENV["CAPTAIN_URL"]
  config.api_version      = "v2"
  config.retry_attempts   = 2
end

def pretty_json(label, data)
  pp label
  pp data
  pp ""
  pp "-----------------------------------"
  pp ""
end
