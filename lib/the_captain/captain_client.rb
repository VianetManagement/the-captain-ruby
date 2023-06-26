# frozen_string_literal: true
require "snowplow-tracker"

module TheCaptain
  class CaptainClient
    attr_accessor :conn
    attr_reader   :response

    REQUEST_METHODS = %i[get post].freeze

    def self.active_client
      Thread.current[:captain_client] || default_client
    end

    def self.default_client
      Thread.current[:captain_default_client] ||= CaptainClient.new(default_conn)
    end

    def self.default_conn
      Thread.current[:captain_default_conn] ||= begin
        HTTP.headers("X-API-KEY" => TheCaptain.api_key)
            .accept("application/json")
            .timeout(
              read:    TheCaptain.read_timeout,
              write:   TheCaptain.write_timeout,
              connect: TheCaptain.connect_timeout,
            )
      end
    end

    def initialize(conn = nil)
      @conn        = conn || self.class.default_conn
      @captain_url = TheCaptain.api_url
    end

    def request(verb_method, path, params = {})
      verify_api_key_header!
      verify_request_method!(verb_method)
      capture_response! { send(verb_method.to_sym, destination_url(path), params) }
      send_to_snowplow(params)
      raise_status_error! unless @response.status.success?
      self
    end

    def decode_response
      raise Error::ClientError.missing_response_object unless @response
      Response::CaptainVessel.new(@response)
    end

    protected

    def send_to_snowplow(params)
      url = ENV.fetch("CAPTAIN_SNOWPLOW_URL", "sp.trustcaptain.com")
      schema = ENV.fetch("CAPTAIN_SNOWPLOW_SCHEMA", "iglu:com.trustcaptain/captain_general_event/jsonschema/1-0-3")
      env = ENV.fetch("RAILS_ENV", "development")
      emitter = SnowplowTracker::AsyncEmitter.new(endpoint: url, options: { method: 'post', protocol: 'https', port: 443 })
      tracker = SnowplowTracker::Tracker.new(emitters: emitter, namespace: "roommates-captain-web", "roommates-#{env}", encode_base64: true)
      tracker.set_platform("app")
      tracker.set_user_id(params[:user][:id]) if params.key?(:user) && params[:user].key?(:id)
      tracker.set_useragent(params[:context][:user_agent]) if params.key?(:context) && params[:context].key?(:user_agent)
      tracker.set_user_ipaddress(params[:context][:ip_address]) if params.key?(:context) && params[:context].key?(:ip_address)
      tracker.set_user_fingerprint(params[:user][:browser_fingerprint]) if params.key?(:user) && params[:user].key?(:browser_fingerprint)
      self_desc_json = SnowplowTracker::SelfDescribingJson.new(schema,params)
      tracker.track_self_describing_event(event_json: self_desc_json)
    end

    def capture_response!(retry_count = TheCaptain.retry_attempts)
      @response = yield
    rescue StandardError
      retry_count ||= 0
      (retry_count -= 1).positive? ? retry : raise
    end

    def get(url, params = {})
      @conn.get(url, params: params)
    end

    def post(url, params = {})
      @conn.post(url, json: params)
    end

    private

    def raise_status_error!
      return unless TheCaptain.raise_http_errors?

      case @response.status.code
      when 401
        raise Error::APIAuthorizationError.new("Authorization Error", @response)
      when 500..502
        raise Error::APIConnectionError.new("Problem with server response", @response)
      else
        false
      end
    end

    def verify_api_key_header!
      api_key = @conn.default_options.headers["X-API-KEY"]
      return unless api_key.nil? || api_key.empty?
      raise Error::ClientAuthenticationError.no_key_provided
    end

    def verify_request_method!(verb_method)
      raise Error::ClientInvalidRequestError unless REQUEST_METHODS.include?(verb_method.to_sym)
    end

    def destination_url(path)
      path = path.start_with?("/") || path.empty? ? path : "/#{path}"
      "#{@captain_url}#{path}"
    end
  end
end
