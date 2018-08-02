# frozen_string_literal: true

require "http"
require "ostruct"
require "oj"

require "the_captain/version"

# Exception Classes Container
require "the_captain/error/exceptions"

# Utility Helper classes
require "the_captain/utility/helper"
require "the_captain/utility/configuration"

# Net and responses classes
require "the_captain/response/captain_vessel"
require "the_captain/response/captain_object"
require "the_captain/captain_client"

# Query Classes
require "the_captain/api_resource"
require "the_captain/user"
require "the_captain/ip_address"
require "the_captain/content"

module TheCaptain
  @enabled         = true
  @write_timeout   = 5
  @read_timeout    = 5
  @connect_timeout = 5

  class << self
    attr_accessor :enabled, :write_timeout, :read_timeout, :connect_timeout

    def enabled?
      @enabled
    end

    def configure
      yield configuration
    end

    def configuration
      @configuration      ||= Utility::Configuration.new
    end

    def api_key
      @api_key            ||= configuration.api_key.strip
    end

    def api_url
      @api_url            ||= configuration.api_url.strip.chomp("/")
    end

    def retry_attempts
      @retry_attempts     ||= configuration.retry_attempts.to_i
    end

    def raise_http_errors?
      @raise_http_errors  ||= configuration.raise_http_errors
    end
  end
end
