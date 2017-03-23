module TheCaptain
  module Communication
    module Response
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def review_response(response, opts = {})
          hashed_body = JSON.parse(response.body).tap do |body|
            body[:status] = response.status
          end

          parsed_response = Hashie::Mash.new(hashed_body)

          handle_api_error(parsed_response, opts)
        rescue JSON::ParserError
          raise TheCaptain::APIError.invalid_response(response.body.inspect, response.status)
        end

        def handle_api_error(response, opts = {})
          case response.status
          when 200..204
            response
          when 400
            raise TheCaptain::InvalidRequestError.new(response.errors, response, opts)
          when 401
            raise TheCaptain::AuthenticationError.new(response.errors, response, opts)
          when 404
            raise TheCaptain::InvalidRequestError.new(response.errors, response, opts)
          when 500
            raise TheCaptain::APIError.new(response.errors, response, opts)
          when 502
            raise TheCaptain::APIConnectionError.new(response.errors, response, opts)
          else
            raise TheCaptain::TheCaptainError.new(response.errors, response, opts)
          end
        end
      end # ClassMethods
    end
  end
end
