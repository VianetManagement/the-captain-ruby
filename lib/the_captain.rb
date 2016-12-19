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
require "the_captain/model_adapters/railtie" if defined?(Rails)

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
require "the_captain/ip_address"

# Errors
require "the_captain/errors/the_captain_error"
require "the_captain/errors/api_error"
require "the_captain/errors/api_connection_error"
require "the_captain/errors/invalid_request_error"
require "the_captain/errors/authentication_error"
require "the_captain/errors/rate_limit_error"

# Requests and Responses
require "the_captain/response"
require "the_captain/connection"

require "the_captain"

module TheCaptain
  include TheCaptain::Connection
  include TheCaptain::Response

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
  end
end
