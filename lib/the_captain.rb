require 'faraday'
require 'typhoeus/adapters/faraday'
require 'hashie'
require 'json'
require 'time'
require 'set'
require 'socket'

require 'ext/hash'
require 'ext/string'

require 'the_captain/util'
require 'the_captain/configuration'
require 'the_captain/errors'

%w(request create read query).each {|a| require "the_captain/api_operations/#{a}"}
%w(model api_resource ip event).each {|a| require "the_captain/#{a}"}

module TheCaptain
	DEFAULT_HEADERS = {
  	'Accept' 			 => 'application/json',
  	'Content-Type' => 'application/json'
  }

  @open_timeout = 30
  @read_timeout = 80

  class << self
  	attr_accessor :open_timeout, :read_timeout

  	def last_response=(response)
			@last_response = response
		end

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

		def last_response
			@last_response
		end

  	def configure
    	yield configuration
  	end

  	def ssl?
  		@ssl ||= configuration.base_url.include?('https')
  	end

  	def api_base_url
  		@api_base_url ||= "#{base_url}/#{api_version}"
  	end

  	def api_url(url = '', api_base_url = nil)
    	"#{api_base_url}/#{url}"
  	end

  	def request(method, path, params = {}, opts = {})
  		validate_api_key!

	    url = api_url(path, api_base_url)
	    headers = opts[:headers] || DEFAULT_HEADERS
	    headers.merge!('X-API-TOKEN' => api_key)

	    opts.update(
	    	headers: request_headers(method).update(headers),
				method: method,
				open_timeout: open_timeout,
				payload: params,
				url: url,
				timeout: read_timeout
			)

	    response = execute_request_with_rescues(method, params, opts, path)
	    parse(response)
	  end

	  def request_headers(method)
	  	user_agent_string = "TheCaptain/v1 RubyBindings/#{TheCaptain::VERSION}"
	    headers = DEFAULT_HEADERS.merge(
	      user_agent: user_agent_string
	    )

	    begin
	      headers.update(x_the_captain_client_user_agent: JSON.generate(user_agent))
	    rescue => e
	      headers.update(
	      	x_the_captain_client_raw_user_agent: user_agent.inspect,
					error: "#{e} (#{e.class})"
				)
	    end
	  end

	  def user_agent
	    lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"

	    {
	      bindings_version: TheCaptain::VERSION,
	      lang: 'ruby',
	      lang_version: '2.2.3',
	      engine: defined?(RUBY_ENGINE) ? RUBY_ENGINE : '',
	      publisher: 'The Captain',
	      uname: @uname,
	      hostname: Socket.gethostname
	    }

	  end

	  def parse(response)
	    begin
	      r = JSON.parse(response.body)
	      r = Util.symbolize_names(r)
	      r[:status] = response.status
	      mash = Util.mashify(r)
	    rescue JSON::ParserError
	    	# The Captain responds with an empty body when creating events.
	    	if response.status == 201
	    		response
	    	else
	    		raise "JSON parse error"
	    	end
	      # raise general_api_error(response.code, response.body)
	    end
	  end

	  protected

	  def execute_request_with_rescues(method, params, opts, path)
	    begin
	      response = execute_request(method, params, opts, path)
	    rescue SocketError => e
	    	raise e
	      # response = handle_restclient_error(e, request_opts, retry_count, path)
	    end

	    response
	  end

	  def validate_api_key!
	  	unless api_key
	      raise AuthenticationError.new('No API key provided. ' \
	        'Set your API key using "TheCaptain.api_key = <API-KEY>". ' \
	        'See https://thecaptain.elevatorup.com/ for details, or ' \
	        'email support@thecaptain.elevatorup.com if you have any questions.')
	    end

	    if api_key =~ /\s/
	      raise AuthenticationError.new('Your API key is invalid, as it contains ' \
	        'whitespace. (HINT: You can double-check your API key by emailing us at ' \
	        'support@thecaptain.elevatorup.com if you have any questions.)')
	    end
	  end

	  def execute_request(method, params, opts, path)
  		connection.send(method) do |req|
  			req.url("#{api_version}/#{path}")
  			req.headers = opts[:headers]
  			req.params = params
  			req.body = opts[:body].to_json if [:post, :patch, :put]
  			#req.options.open_timeout = open_timeout
  		end
		end

	  # @protected
    def connection
    	return @connection if @connection

    	@connection = Faraday.new(url: base_url) do |faraday|
      	faraday.adapter :typhoeus
      end

      @connection.options.timeout      = 30
    	@connection.options.open_timeout = 50
    	@connection.ssl.verify           = false
    	@connection
    end
  end
end
