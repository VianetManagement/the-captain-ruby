require 'the_captain'
require 'webmock/rspec'
require 'vcr'
require 'factory_girl'
require 'faker'

ENV["RAILS_ENV"] = "test"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require File.expand_path(f) }

FactoryGirl.find_definitions
FileUtils.rm(Dir["#{VCR.configuration.cassette_library_dir}/*"]) if ENV['VCR_REFRESH'] == 'true'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

RSpec.configure do |config|
	# config.include ApiHelpers

  # def cassette(*args)
  #   VCR.use_cassette(*args, record: :new_episodes) do
  #     yield
  #   end
  # end
end
