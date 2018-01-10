# frozen_string_literal: true

module TheCaptain
  class APIError < TheCaptainError
    class << self
      def client_error(class_name, message)
        new("It looks like our client raised an #{class_name} error with message:  #{message}")
      end

      def invalid_response(body_inspect, status)
        new("Invalid response object from API: #{body_inspect} (HTTP response code was #{status})")
      end
    end
  end
end
