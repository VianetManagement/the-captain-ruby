require "faraday"
require "typhoeus/adapters/faraday"
require "hashie"
require "json"
require "time"
require "set"
require "socket"

require "ext/hash"
require "ext/string"

require "the_captain/version"

# Api Operations
require "the_captain/api_operations/request"
require "the_captain/api_operations/create"
require "the_captain/api_operations/read"
require "the_captain/api_operations/query"

# Resources
require "the_captain/util"
require "the_captain/configuration"

require "the_captain/model"
require "the_captain/api_resource"
require "the_captain/ip"

# Errors
require "the_captain/errors/the_captain_error"
require "the_captain/errors/api_error"
require "the_captain/errors/api_connection_error"
require "the_captain/errors/invalid_request_error"
require "the_captain/errors/authentication_error"
require "the_captain/errors/rate_limit_error"

require "the_captain"

module TheCaptain
  @open_timeout = 30
  @read_timeout = 80

  class << self
    attr_accessor :open_timeout, :read_timeout

    attr_writer :last_response

    def configuration
      @configuration ||= Configuration.new
    end

    def api_key
      @api_key ||= configuration.server_api_token
    end

    def api_version
      @api_version ||= configuration.api_version
    end

    def base_url
      @base_url ||= configuration.base_url
    end

    attr_reader :last_response

    def configure
      yield configuration
    end

    def ssl?
      @ssl ||= configuration.base_url.include?("https")
    end

    def api_base_url
      @api_base_url ||= "#{base_url}/#{api_version}"
    end

    def api_url(url = "")
      "#{api_base_url}#{url}"
    end

    def request(method, path, params = {}, opts = {})
      validate_api_key!
      headers = prepare_api_headers(opts).merge!("X-API-TOKEN" => api_key)

      opts.update(
        headers: request_headers(method).update(headers),
        method: method,
        open_timeout: open_timeout,
        payload: params,
        url: api_url(path),
        timeout: read_timeout,
      )

      response = execute_request_with_rescues(method, params, opts, path)
      parse(response)
    end

    def request_headers(_method)
      user_agent_string = "TheCaptain/v1 RubyBindings/#{TheCaptain::VERSION}"
      headers = prepare_api_headers.merge(
        user_agent: user_agent_string,
      )

      begin
        headers.update(x_the_captain_client_user_agent: JSON.generate(user_agent))
      rescue StandardError => e
        headers.update(
          x_the_captain_client_raw_user_agent: user_agent.inspect,
          error: "#{e} (#{e.class})",
        )
      end
    end

    def user_agent
      {
        bindings_version: TheCaptain::VERSION,
        lang: "ruby",
        lang_version: "2.2.3",
        engine: defined?(RUBY_ENGINE) ? RUBY_ENGINE : "",
        publisher: "The Captain",
        uname: @uname,
        hostname: Socket.gethostname,
      }
    end

    def parse(response)
      r = JSON.parse(response.body)
      r = Util.symbolize_names(r)
      r[:status] = response.status
      Util.mashify(r)
    rescue JSON::ParserError
      # The Captain responds with an empty body when creating events.
      if response.status == 201
        response
      else
        raise APIError, "Invalid response object from API: #{response.body.inspect} " \
              "(HTTP response code was #{response.status})"
      end
    end

    protected

    def prepare_api_headers(opts = {})
      return opts[:headers] if opts[:headers]
      {
        "Accept" 			 => "application/json",
        "Content-Type" => "application/json",
      }
    end

    def handle_api_error(response, opts = {})
      error = response.respond_to?(:error_message) ? response.error_message : nil

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

    def execute_request_with_rescues(method, params, opts, path)
      execute_request(method, params, opts, path)
    rescue => e
      raise APIError, "It looks like our client raised an #{e.class.name} error with message:  #{e.message}"
    end

    def validate_api_key!
      unless api_key
        raise AuthenticationError, "No API key provided. " \
	        'Set your API key using "TheCaptain.api_key = <API-KEY>". ' \
	        "See https://thecaptain.elevatorup.com for details, or " \
	        "email support@thecaptain.elevatorup.com if you have any questions."
      end

      if api_key =~ /\s/
        raise AuthenticationError, "Your API key is invalid, as it contains " \
	        "whitespace. (HINT: You can double-check your API key by emailing us at " \
	        "support@thecaptain.elevatorup.com if you have any questions.)"
      end
    end

    def execute_request(method, params, opts, path)
      connection.send(method) do |req|
        req.url(api_url(path))
        req.headers = opts[:headers]
        req.params = params
        req.body = opts[:body].to_json if [:post, :patch, :put].include?(method)
      end
    end

    # @protected
    def connection
      return @connection if @connection

      @connection = Faraday.new(url: base_url) do |faraday|
        faraday.adapter :typhoeus
      end

      @connection.options.timeout = 30
      @connection.options.open_timeout = 50
      @connection.ssl.verify = false
      @connection
    end
  end
end
