module TheCaptain
  module Utility
    class Configuration
      attr_accessor :server_api_token
      attr_accessor :site_id
      attr_accessor :api_version
      attr_accessor :base_url

      def to_h
        {
          server_api_token: server_api_token,
          api_version: api_version,
          base_url: base_url,
        }
      end
    end
  end
end
