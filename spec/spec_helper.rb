# frozen_string_literal: true

require "bundler/setup"
require "rspec/its"
require "dotenv/load"
require "the_captain"

Dotenv.load("test.env") unless ENV["CI"]

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require File.expand_path(f) }
Dir["#{File.dirname(__FILE__)}/**/*examples.rb"].each { |f| require f }

module TheCaptain
  class << self
    def reset_configurations!
      @api_key           = nil
      @api_url           = nil
      @configuration     = nil
      @retry_attempts    = nil
      @raise_http_errors = nil
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
