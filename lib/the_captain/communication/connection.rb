require "the_captain/communication/response"

module TheCaptain
  module Communication
    module Connection
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def request(method, path, params = {}, opts = {})
          validate_api_key!

          opts.update(
            headers: prepare_api_headers,
            method: method,
            open_timeout: open_timeout,
            payload: params,
            url: api_url(path),
            timeout: read_timeout,
          )

          response = execute_request_with_rescues(method, params, opts, path)
          parse(response, opts) # TheCaptain::Communication::Response.parse
        end

        private

        # @private
        def validate_api_key!
          raise TheCaptain::AuthenticationError.no_key_provided unless api_key
          raise TheCaptain::AuthenticationError.invalid_key_provided if api_key =~ /\s/
        end

        def prepare_api_headers(opts = {})
          return opts[:headers] if opts[:headers]
          {
            "Accept" 			 => "application/json",
            "Content-Type" => "application/json",
            "X-API-KEY"    => api_key,
          }
        end

        protected

        # @protected
        def execute_request_with_rescues(method, params, opts, path)
          execute_request(method, params, opts, path)
        rescue => e
          raise TheCaptain::APIError.client_error(e.class.name, e.message)
        end

        # @protected
        def execute_request(method, params, opts, path)
          connection.send(method) do |req|
            req.url(api_url(path))
            req.headers = opts[:headers]
            req.params  = params
            req.body    = opts[:body].to_json if [:post, :patch, :put].include?(method)
          end
        end

        # @protected
        def connection
          return @connection if @connection
          @connection = Faraday.new(url: base_url) do |faraday|
            faraday.adapter :typhoeus
            faraday.options.timeout      = 30
            faraday.options.open_timeout = 50
            faraday.ssl.verify           = ssl?
          end
        end
      end # ClassMethods
    end
  end
end
