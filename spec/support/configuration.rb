RSpec.configure do |config|
	TheCaptain.configure do |config|
	  config.site_id = '1'
	  config.api_version = 'v1'
	  config.base_url = 'https://api.thecaptain.elevatorup.com'
	end
end
