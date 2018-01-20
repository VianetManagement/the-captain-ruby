# frozen_string_literal: true

require "faraday"
require "hashie"
require "json"
require "socket"
require "active_support/core_ext/object/blank"

# Gem Version
require "the_captain/version"

module TheCaptain
  autoload :ApiResource,           "the_captain/api_resource"
  autoload :Model,                 "the_captain/model"
  autoload :Submit,                "the_captain/submit"
  autoload :List,                  "the_captain/list"
  autoload :ListCollection,        "the_captain/list_collection"
  autoload :ListItem,              "the_captain/list_item"
  autoload :Info,                  "the_captain/info"
  autoload :Event,                 "the_captain/event"
  autoload :Stats,                 "the_captain/stats"
  autoload :Usage,                 "the_captain/usage"
  autoload :User,                  "the_captain/user"
  autoload :UserCollection,        "the_captain/user_collection"

  module Utility
    autoload :Configuration,       "the_captain/utility/configuration"
  end

  module Communication
    autoload :Response,            "the_captain/communication/response"
    autoload :Connection,          "the_captain/communication/connection"
  end

  module APIOperations
    autoload :Crud,                "the_captain/api_operations/crud"
  end

  module Error
    autoload :StandardException,   "the_captain/error/standard_exception"
    autoload :APIError,            "the_captain/error/api_error"
    autoload :APIConnectionError,  "the_captain/error/api_connection_error"
    autoload :InvalidRequestError, "the_captain/error/invalid_request_error"
    autoload :AuthenticationError, "the_captain/error/authentication_error"
    autoload :RateLimitError,      "the_captain/error/rate_limit_error"
    autoload :ValidationError,     "the_captain/error/validation_error"
  end

  include TheCaptain::Communication::Connection
  include TheCaptain::Communication::Response

  @open_timeout = 50
  @read_timeout = 80
  @enabled      = true

  class << self
    attr_accessor :open_timeout, :read_timeout, :last_response, :enabled

    def configuration
      @configuration      ||= Utility::Configuration.new
    end

    def api_key
      @api_key            ||= configuration.server_api_token
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

  require "the_captain/model_adapters/railtie" if defined?(Rails)
end
