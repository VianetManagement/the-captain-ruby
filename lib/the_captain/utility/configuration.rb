# frozen_string_literal: true

module TheCaptain
  module Utility
    class Configuration
      attr_accessor :base_url
      attr_accessor :api_version
      attr_accessor :server_api_token
      attr_accessor :retry_attempts
      attr_accessor :connection_adapter

      def initialize
        @api_version        = "v2"
        @connection_adapter = Faraday.default_adapter
      end

      def to_h
        {
          server_api_token: server_api_token,
          api_version: api_version,
          base_url: base_url,
          connection_adapter: connection_adapter,
          retry_attempts: retry_attempts,
        }.freeze
      end
    end
  end
end
