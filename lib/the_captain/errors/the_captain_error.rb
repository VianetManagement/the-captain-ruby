module TheCaptain
  class TheCaptainError < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :http_body
    attr_reader :http_headers
    attr_reader :http_params
    attr_reader :json_body
    attr_reader :request_id
    attr_reader :user_agent

    def initialize(message, response = nil, request_options = {})
      @message	= message
      @http_headers = request_options[:headers] || {}
      @json_body	= request_options[:body]

      if response
        @http_status = response.status
        @http_body	= response.body
        @request_id 	= response.headers["X-Request-Id"]
        @user_agent 	= response.headers["User-Agent"]
      end
    end

    def to_s
      status_string = http_status.nil? ? "" : "(Status #{http_status}) "
      id_string = request_id.nil? ? "" : "(Request #{request_id}) "
      user_agent_string = user_agent.nil? ? "" : "(User-Agent #{user_agent})"
      "#{status_string}#{id_string}#{user_agent_string}#{message}"
    end
  end
end
