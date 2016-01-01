module TheCaptain
	class Configuration
		attr_accessor :server_api_token
		attr_accessor :site_id
		attr_accessor :api_version
		attr_accessor :base_url

		def to_h
			{
				server_api_token: server_api_token,
				site_id: site_id,
				api_version: api_version,
				base_url: base_url,
			}
		end
	end
end
