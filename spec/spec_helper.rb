require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'the_captain'
require 'webmock/rspec'
require 'vcr'
require 'factory_girl'
require 'faker'
require 'timecop'

ENV['RAILS_ENV'] = 'test'
ENV['API_VERSION'] = 'v1'
ENV['BASE_URL'] = 'https://api.thecaptain.elevatorup.com'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each{ |f| require File.expand_path(f) }

FactoryGirl.find_definitions
WebMock.disable_net_connect!(allow: 'codeclimate.com')
