# frozen_string_literal: true

module TheCaptain
  module Utility
    class Configuration
      attr_accessor :base_url, :api_version, :server_api_token, :retry_attempts

      def initialize
        @api_version = "v2"
      end

      def to_h
        {
          server_api_token: server_api_token,
          base_url:         base_url,
          api_version:      api_version,
          retry_attempts:   retry_attempts,
        }.freeze
      end
    end
  end
end
