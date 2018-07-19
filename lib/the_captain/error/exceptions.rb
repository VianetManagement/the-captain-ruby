# frozen_string_literal: true

require "the_captain/error/standard_exception"

module TheCaptain
  module Error
    class APIConnectionError < StandardException; end
    class InvalidRequestError < StandardException; end
    class RateLimitError < StandardException; end

    class APIError < StandardError
      def self.client_error(class_name, message)
        new("It looks like our client raised an #{class_name} error with message:  #{message}")
      end

      def self.invalid_response(body_inspect, status)
        new("Invalid response object from API: #{body_inspect} (HTTP response code was #{status})")
      end
    end

    class AuthenticationError < StandardException
      def self.no_key_provided
        new("No API key provided. " \
	        'Set your API key using "TheCaptain.api_key = <API-KEY>". ' \
	        "See https://thecaptain.elevatorup.com for details, or " \
	        "email support@thecaptain.elevatorup.com if you have any questions.")
      end

      def self.invalid_key_provided
        new("Your API key is invalid, as its not of string type." \
	        "(HINT: You can double-check your API key by emailing us at " \
	        "support@thecaptain.elevatorup.com if you have any questions.)")
      end
    end
  end
end
