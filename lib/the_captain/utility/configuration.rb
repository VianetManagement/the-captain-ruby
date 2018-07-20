# frozen_string_literal: true

module TheCaptain
  module Utility
    class Configuration
      attr_accessor :base_url, :api_version, :api_key, :retry_attempts, :raise_http_errors

      def initialize
        @api_version       = ENV.fetch("CAPTAIN_API_VERSION", "v2")
        @api_key           = ENV.fetch("CAPTAIN_API_KEY", "")
        @base_url          = ENV.fetch("CAPTAIN_API_URL", "https://thecaptain.elevatorup.com")
        @raise_http_errors = false
      end

      def to_h
        {
          api_key:        api_key,
          base_url:       base_url,
          api_version:    api_version,
          retry_attempts: retry_attempts,
          raise_http_errors: raise_http_errors,
        }.freeze
      end
    end
  end
end
