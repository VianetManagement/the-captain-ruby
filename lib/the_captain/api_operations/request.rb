module TheCaptain
  module APIOperations
    module Request
      module ClassMethods
        def request(method:, path:, params: {}, opts: {})
	        request_body = opts[:body]
	        query = opts[:query] || {}

          response = TheCaptain.request(method, path, params, opts)
          TheCaptain.last_response = response

          case response.status
	        when 200..204
	          response
	        when 400
	          raise TheCaptain::BadRequest.new(error, response, error_obj)
	        when 401
	          raise TheCaptain::AuthenticationFailed.new(response, params)
	        when 404
	          raise TheCaptain::NotFound.new(response, params)
	        when 422
	          raise TheCaptain::UnprocessibleEntity.new(response, params)
	        when 500
	          raise TheCaptain::ServerError.new(response, params)
	        when 502
	          raise TheCaptain::Unavailable.new(response, params)
	        else
	          raise TheCaptain::InformTheCaptain.new(response, params)
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
