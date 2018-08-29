# frozen_string_literal: true

module TheCaptain
  module Utility
    class Configuration
      attr_accessor :api_url, :api_key, :retry_attempts, :raise_http_errors

      def initialize
        @api_key           = ENV.fetch("CAPTAIN_API_KEY", "")
        @api_url           = ENV.fetch("CAPTAIN_API_URL", "https://thecaptain.elevatorup.com/v3")
        @retry_attempts    = 0
        @raise_http_errors = false
      end

      def to_h
        {
          api_key:           api_key,
          api_url:           api_url,
          api_version:       api_version,
          retry_attempts:    retry_attempts,
          raise_http_errors: raise_http_errors,
        }.freeze
      end
    end
  end
end
