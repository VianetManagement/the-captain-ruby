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
      # capture_response! { send(verb_method.to_sym, destination_url(path), params) }
      send_to_vianet_admin(params)
      send_to_snowplow(params)
      raise_status_error! unless @response.status.success?
      self
    end

    def decode_response
      raise Error::ClientError.missing_response_object unless @response
      Response::CaptainVessel.new(@response)
    end

    protected

    def send_to_vianet_admin(params)
      user_id = if params.key?(:user) && params[:user].key?(:id)
        params[:user][:id]
      else
        nil
      end
      return if user_id == nil

      begin
        url = ENV.fetch("VIANET_ADMIN_URL", "")
        post(url, {site: "roommates", user_id: user_id})
      catch StandardError => e
        Rails.logger.error e
      end
    end

    def send_to_snowplow(params)
      snowplow_params = params.dup
      url = ENV.fetch("CAPTAIN_SNOWPLOW_URL", "sp.trustcaptain.com")
      schema = ENV.fetch("CAPTAIN_SNOWPLOW_SCHEMA", "")
      env = ENV.fetch("RAILS_ENV", "development")
      snowplow_params["api_key"] = TheCaptain.api_key
      emitter = SnowplowTracker::Emitter.new(endpoint: url, options: { method: 'post', protocol: 'https', port: 443, buffer_size: 1 })
      tracker = SnowplowTracker::Tracker.new(emitters: emitter, namespace: "roommates-captain-web", app_id: "roommates-#{env}", encode_base64: true)
      tracker.set_user_id(snowplow_params[:user][:id]) if snowplow_params.key?(:user) && snowplow_params[:user].key?(:id)
      tracker.set_useragent(snowplow_params[:context][:user_agent]) if snowplow_params.key?(:context) && snowplow_params[:context].key?(:user_agent)
      tracker.set_ip_address(snowplow_params[:context][:ip_address]) if snowplow_params.key?(:context) && snowplow_params[:context].key?(:ip_address)
      tracker.set_fingerprint(snowplow_params[:user][:browser_fingerprint]) if snowplow_params.key?(:user) && snowplow_params[:user].key?(:browser_fingerprint)
      self_desc_json = SnowplowTracker::SelfDescribingJson.new(schema, snowplow_params)
      res = tracker.track_self_describing_event(event_json: self_desc_json)
      tracker.flush
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
