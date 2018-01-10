# frozen_string_literal: true

require "faraday"
require "typhoeus/adapters/faraday"
require "hashie"
require "json"
require "time"
require "set"
require "socket"
require "active_support"
require "active_support/core_ext"

require "the_captain/version"
require "the_captain/model_adapters/railtie" if defined?(Rails)

# Api Operations
require "the_captain/api_operations/crud"

# Resources
require "the_captain/utility/configuration"
require "the_captain/model"
require "the_captain/api_resource"

# Core Captain models
require "the_captain/submit"
require "the_captain/info"
require "the_captain/list"
require "the_captain/event"
require "the_captain/stats"
require "the_captain/usage"
require "the_captain/user"

# Errors
require "the_captain/errors/the_captain_error"
require "the_captain/errors/api_error"
require "the_captain/errors/api_connection_error"
require "the_captain/errors/invalid_request_error"
require "the_captain/errors/authentication_error"
require "the_captain/errors/rate_limit_error"
require "the_captain/errors/validation_error"

# Requests and Responses
require "the_captain/communication/response"
require "the_captain/communication/connection"

require "the_captain"

module TheCaptain
  include TheCaptain::Communication::Connection
  include TheCaptain::Communication::Response

  @open_timeout = 50
  @read_timeout = 80
  @enabled      = true

  class << self
    attr_accessor :open_timeout, :read_timeout, :last_response, :enabled

    def configuration
      @configuration  ||= Utility::Configuration.new
    end

    def api_key
      @api_key        ||= configuration.server_api_token
    end

    def api_version
      @api_version    ||= configuration.api_version || "v2"
    end

    def base_url
      @base_url       ||= configuration.base_url.chomp("/")
    end

    def retry_attempts
      @retry_attempts ||= configuration.retry_attempts.to_i
    end

    def configure
      yield configuration
    end

    def enabled?
      @enabled
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
  end
end
