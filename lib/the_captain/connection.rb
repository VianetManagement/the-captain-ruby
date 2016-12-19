require "the_captain/response"

module TheCaptain::Connection
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def request(method, path, params = {}, opts = {})
      validate_api_key!

      opts.update(
        headers: request_headers(opts).merge!("X-API-KEY" => api_key),
        method: method,
        open_timeout: open_timeout,
        payload: params,
        url: api_url(path),
        timeout: read_timeout,
      )

      response = execute_request_with_rescues(method, params, opts, path)
      parse(response) # TheCaptain::Response.parse
    end

    private

    def validate_api_key!
      raise TheCaptain::AuthenticationError.no_key_provided unless api_key
      raise TheCaptain::AuthenticationError.invalid_key_provided if api_key =~ /\s/
    end

    def prepare_api_headers(opts = {})
      return opts[:headers] if opts[:headers]
      {
        "Accept" 			 => "application/json",
        "Content-Type" => "application/json",
      }
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

    def request_headers(opts)
      user_agent_string = "TheCaptain/v1 RubyBindings/#{TheCaptain::VERSION}"
      headers = prepare_api_headers(opts).merge(user_agent: user_agent_string)

      begin
        headers.update(x_the_captain_client_user_agent: JSON.generate(user_agent))
      rescue StandardError => e
        headers.update(
          x_the_captain_client_raw_user_agent: user_agent.inspect,
          error: "#{e} (#{e.class})",
        )
      end
    end

    protected

    def execute_request_with_rescues(method, params, opts, path)
      execute_request(method, params, opts, path)
    rescue => e
      raise TheCaptain::APIError.client_error(e.class.name, e.message)
    end

    def execute_request(method, params, opts, path)
      connection.send(method) do |req|
        req.url(api_url(path))
        req.headers = opts[:headers]
        req.params = params
        req.body = opts[:body].to_json if [:post, :patch, :put].include?(method)
      end
    end

    def connection
      return @connection if @connection
      @connection = Faraday.new(url: base_url) { |faraday| faraday.adapter :typhoeus }
      @connection.options.timeout = 30
      @connection.options.open_timeout = 50
      @connection.ssl.verify = false
      @connection
    end
  end # ClassMethods
end
