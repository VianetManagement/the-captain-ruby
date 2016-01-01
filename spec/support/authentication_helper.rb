module AuthenticationHelper
	def authenticate!
		TheCaptain.configure do |config|
		  config.server_api_token = 'gJSTIXixI2GTWzVd6ALuWg'
		end
	end

	def self.reset_authentication!
		TheCaptain.configure do |config|
		  config.server_api_token = nil
		end
	end

	def reset_authentication!
		AuthenticationHelper.reset_authentication!
	end
end

RSpec.configure do |config|
	config.include(AuthenticationHelper)
	config.before(:each){ |scenario| AuthenticationHelper.reset_authentication! }
end
