# frozen_string_literal: true

module TheCaptain
  class CaptainClient
    attr_accessor :conn
    attr_reader   :response

    REQUEST_METHODS = %i[get post patch].freeze

    def self.active_client
      Thread.current[:captain_client] || default_client
    end

    def self.default_client
      Thread.current[:captain_default_client] ||= CaptainClient.new(default_conn)
    end

    def self.default_conn
      Thread.current[:captain_default_client] ||= begin
        HTTP.headers("X-API-KEY" => TheCaptain.api_key)
            .accept("application/json")
            .timeout(
              read:       TheCaptain.read_timeout,
              write:      TheCaptain.write_timeout,
              connection: TheCaptain.connection_timeout,
            )
      end
    end

    def initialize(conn = nil)
      @conn        = conn || self.class.default_conn
      @captain_url = TheCaptain.api_base_url
    end

    def request(verb_method, path, params = {})
      verify_api_key_header!
      verify_request_method!(verb_method)
      capture_response! { send(verb_method.to_sym, destination_url(path), params) }
      self
    end

    def decode_response
      raise Error::MissingClientResponse.no_response unless @response
      Response::CaptainContainer.new(@response)
    end

    protected

    def capture_response!(retry_count = TheCaptain.retry_attempts)
      @response = yield
    rescue StandardError
      retry_count -= 1
      retry_count.positive? ? retry : raise
    end

    def get(url, params = {})
      @conn.get(url, params: params)
    end

    def post(url, params = {})
      @conn.post(url, form: params)
    end

    def patch(url, params = {})
      @conn.patch(url, form: params)
    end

    private

    def verify_api_key_header!
      api_key = @conn.default_options.headers["X-API-KEY"]
      return unless api_key.nil? || api_key.empty?
      raise Error::AuthenticationError.no_key_provided
    end

    def verify_request_method!(verb_method)
      raise Error::InvalidRequestError unless REQUEST_METHODS.include?(verb_method.to_sym)
    end

    def destination_url(path)
      path = path.start_with?("/") ? path : "/#{path}"
      "#{@captain_url}#{path}"
    end
  end
end
