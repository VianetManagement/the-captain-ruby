module TheCaptain
  module APIOperations
    module Request
      module ClassMethods
        def request(method:, path:, params: {}, opts: {})
	        request_body = opts[:body]
	        query = opts[:query] || {}

          response = TheCaptain.request(method, path, params, opts)
          TheCaptain.last_response = response

          request_options = {
          	method: method,
          	path: path,
          	body: request_body,
          	params: params,
          	opts: opts
          }

          error = response.respond_to?(:error_message) ? response.error_message : nil

          case response.status
	        when 200..204
	          response
	        when 400
	          raise TheCaptain::BadRequest.new(error, request_options, response)
	        when 401
	          raise TheCaptain::AuthenticationFailed.new(error, request_options, response)
	        when 404
	          raise TheCaptain::NotFound.new(error, request_options, response)
	        when 500
	          raise TheCaptain::ServerError.new(error, request_options, response)
	        when 502
	          raise TheCaptain::Unavailable.new(error, request_options, response)
	        else
	          raise TheCaptain::InformTheCaptain.new(error, request_options, response)
	        end

          response
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
