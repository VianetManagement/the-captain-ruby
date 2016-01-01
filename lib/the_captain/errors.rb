module TheCaptain
  class InvalidCredentials < StandardError; end

  class HTTPError < StandardError
    attr_reader :response
    attr_reader :params

    def initialize(message, request_options, response)
    	@message = message
      @response = response
      @request_options = request_options
      super(response)
    end

    def to_s
      "#{self.class.to_s} : #{response.code} #{response.body}"
    end
  end

  class NotFound < HTTPError; end
  class Unavailable < HTTPError; end
  class UnprocessibleEntity < HTTPError; end
  class InformTheCaptain < HTTPError; end
  class BadRequest < HTTPError; end
  class ServerError < HTTPError; end
  class AuthenticationFailed < HTTPError ; end
end
