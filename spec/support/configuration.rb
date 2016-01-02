RSpec.configure do |config|
	TheCaptain.configure do |config|
	  config.site_id = '1'
	  config.api_version = ENV.fetch('API_VERSION')
	  config.base_url = ENV.fetch('BASE_URL')
	end
end
