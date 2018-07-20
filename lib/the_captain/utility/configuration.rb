# frozen_string_literal: true

module TheCaptain
  module Utility
    class Configuration
      attr_accessor :base_url, :api_version, :api_key, :retry_attempts

      def initialize
        @api_version = "v2"
        @base_url    = "https://thecaptain.elevatorup.com"
      end

      def to_h
        {
          api_key:        api_key,
          base_url:       base_url,
          api_version:    api_version,
          retry_attempts: retry_attempts,
        }.freeze
      end
    end
  end
end
