# frozen_string_literal: true

require "dotenv/load"
require "the_captain"

Dotenv.load!("../development.env")

TheCaptain.configure do |config|
  config.retry_attempts = 2
end

@ip_address_v4 = "127.0.0.1"
@numbers       = (200..5000).to_a

def generate_user
  { user: {}, context: {} }.tap do |data|
    num = @numbers.sample
    data[:action]               = "user:created"
    data[:user][:id]            = num
    data[:user][:name]          = "George's Test"
    data[:user][:role]          = "member"
    data[:user][:email_address] = "george+#{num}@example.com"
    data[:context][:ip_address] = @ip_address_v4
  end
end

user_data = generate_user
TheCaptain::Collect.submit(user_data)
