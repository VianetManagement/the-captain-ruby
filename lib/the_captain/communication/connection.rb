# frozen_string_literal: true

require "the_captain/communication/response"

module TheCaptain
  module Communication
    module Connection
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def request(method, path, params = {}, opts = {})
          return captain_disabled! unless TheCaptain.enabled?

          validate_api_key!

          opts.update(
            method:       method,
            url:          api_url(path),
            headers:      prepare_api_headers,
            payload:      params,
            timeout:      read_timeout,
            open_timeout: open_timeout,
          )

          with_retry do
            response = execute_request_with_rescues(method, params, opts, path)
            review_response(response, opts) # TheCaptain::Communication::Response.review_response
          end
        end

        private

        # Retry's the same request after a failure or exception is risen
        def with_retry
          return unless block_given?

          retry_attempts   = TheCaptain.retry_attempts || 0
          retry_attempts   = retry_attempts > 1 ? retry_attempts - 1 : retry_attempts
          results          = false

          retry_attempts.times do
            begin
              results = yield
              break
            rescue StandardError
              next
            end
          end

          results ? results : yield
        end

        # @private
        def validate_api_key!
          raise TheCaptain::Error::AuthenticationError.no_key_provided if api_key.blank?
          raise TheCaptain::Error::AuthenticationError.invalid_key_provided unless api_key.is_a?(String)
        end

        def captain_disabled!
          Hashie::Mash.new(
            error: "The Captain Gem is disabled! Enable via `TheCaptain.enabled = true`",
            disabled: !TheCaptain.enabled?,
          )
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
        rescue StandardError => e
          raise TheCaptain::Error::APIError.client_error(e.class.name, e.message)
        end

        # @protected
        def execute_request(method, params, opts, path)
          connection.send(method) do |req|
            req.url(api_url(path))
            req.headers = opts[:headers]
            req.params  = params
            req.body    = opts[:body].to_json unless [:get].include?(method)
          end
        end

        # @protected
        def connection
          return @connection if @connection
          @connection = Faraday.new(url: base_url) do |faraday|
            faraday.adapter :typhoeus
            faraday.options.timeout      = read_timeout
            faraday.options.open_timeout = open_timeout
            faraday.ssl.verify           = ssl?
          end
        end
      end
      # ClassMethods
    end
  end
end
