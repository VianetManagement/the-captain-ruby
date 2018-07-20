# frozen_string_literal: true

require "http"
require "ostruct"
require "oj"

require "the_captain/version"

# Exception Classes Container
require "the_captain/error/exceptions"

# Utility Helper classes
require "the_captain/utility/helper"
require "the_captain/utility/validation"
require "the_captain/utility/configuration"

# Net and responses classes
require "the_captain/response/captain_container"
require "the_captain/response/captain_object"
require "the_captain/captain_client"

# Query Classes
require "the_captain/api_resource"
require "the_captain/user"
require "the_captain/ip_address"
require "the_captain/message"
require "the_captain/stats"

module TheCaptain
  @enabled            = true
  @write_timeout      = 5
  @read_timeout       = 5
  @connection_timeout = 5

  class << self
    attr_accessor :write_timeout, :read_timeout, :connection_timeout, :last_response, :enabled

    def configuration
      @configuration      ||= Utility::Configuration.new
    end

    def api_key
      @api_key            ||= configuration.api_key.strip
    end

    def api_version
      @api_version        ||= configuration.api_version
    end

    def base_url
      @base_url           ||= configuration.base_url.chomp("/")
    end

    def connection_adapter
      @connection_adapter ||= configuration.connection_adapter
    end

    def retry_attempts
      @retry_attempts     ||= configuration.retry_attempts.to_i
    end

    def configure
      yield configuration
    end

    def enabled?
      @enabled
    end

    def raise_http_errors?
      configuration.raise_http_errors
    end

    def ssl?
      @ssl ||= configuration.base_url.include?("https")
    end

    def api_base_url
      @api_base_url ||= "#{base_url}/#{api_version}"
    end
  end

  require "the_captain/model_adapters/railtie" if defined?(Rails)
end
