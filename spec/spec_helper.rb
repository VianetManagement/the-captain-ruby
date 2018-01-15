# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "dotenv/load"
Dotenv.load("test.env") unless ENV["CI"]

require "the_captain"
require "faker"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require File.expand_path(f) }
Dir["#{File.dirname(__FILE__)}/**/*examples.rb"].each { |f| require f }
