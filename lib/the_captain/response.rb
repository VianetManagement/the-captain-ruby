module TheCaptain::Response
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def parse(response)
      r = JSON.parse(response.body)
      r = TheCaptain::Util.symbolize_names(r)
      r[:status] = response.status
      handle_api_error(TheCaptain::Util.mashify(r))
    rescue JSON::ParserError
      # The Captain responds with an empty body when creating events.
      unless response.status == 201
        raise TheCaptain::APIError.invalid_response(response.body.inspect, response.status)
      end
      response
    end

    def handle_api_error(response, opts = {})
      error = response.respond_to?(:error) ? response.error_message : nil
      error ||= response.status.respond_to?(:error) ? response.status.error : nil
      case response.status
      when 200..204
        response
      when 400
        raise TheCaptain::InvalidRequestError.new(error, response, opts)
      when 401
        raise TheCaptain::AuthenticationError.new(error, response, opts)
      when 404
        raise TheCaptain::InvalidRequestError.new(error, response, opts)
      when 500
        raise TheCaptain::APIError.new(error, response, opts)
      when 502
        raise TheCaptain::APIConnectionError.new(error, response, opts)
      else
        raise TheCaptain::TheCaptainError.new(error, response, opts)
      end
    end
  end # ClassMethods
end