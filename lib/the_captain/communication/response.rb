# frozen_string_literal: true

module TheCaptain
  module Communication
    module Response
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Parses the response and returns a parsed response with status checking
        def review_response(response, opts = {})
          handle_api_error(parse_response(response), opts)
        end

        # Parses the JSON response into a usage Hashie::Mash table
        def parse_response(response)
          JSON.parse(response.body).tap do |body|
            body          = Hashie::Mash.new(body)
            body.status   = response.status
          end
        rescue StandardError
          raise TheCaptain::Error::APIError.invalid_response(response.body.inspect, response.status)
        end

        # Checks the status of the response
        #
        # Returns
        #  - Success: response
        #  - Error: Raises Exception TheCaptain::Error::StandardException
        def handle_api_error(response, opts = {}) # rubocop:disable Metrics/AbcSize
          case response.status
          when 200..204
            response
          when 400
            raise TheCaptain::Error::InvalidRequestError.new(response.errors, response, opts)
          when 401
            raise TheCaptain::Error::AuthenticationError.new(response.errors, response, opts)
          when 404
            raise TheCaptain::Error::InvalidRequestError.new(response.errors, response, opts)
          when 500
            raise TheCaptain::Error::APIError.new(response.errors, response, opts)
          when 502
            raise TheCaptain::Error::APIConnectionError.new(response.errors, response, opts)
          else
            raise TheCaptain::Error::StandardException.new(response.errors, response, opts)
          end
        end
      end
      # ClassMethods
    end
  end
end
