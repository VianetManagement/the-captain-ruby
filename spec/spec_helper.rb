require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "dotenv/load"
Dotenv.load("test.env") unless ENV["CI"]

require "the_captain"
require "webmock/rspec"
require "faker"
require "factory_girl"
require "timecop"

# ENV["RAILS_ENV"]   = "test"
ENV["API_VERSION"] = ENV["CAPTAIN_VERSION"] || "v2"
ENV["BASE_URL"]    = ENV["CAPTAIN_URL"]

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require File.expand_path(f) }
Dir["#{File.dirname(__FILE__)}/**/*examples.rb"].each { |f| require f }

FactoryGirl.find_definitions
WebMock.disable_net_connect!(allow: "codeclimate.com")
