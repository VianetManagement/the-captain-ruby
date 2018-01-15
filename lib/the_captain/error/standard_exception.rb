# frozen_string_literal: true

module TheCaptain
  module Error
    class StandardException < StandardError
      attr_reader :message
      attr_reader :http_status
      attr_reader :http_body
      attr_reader :http_headers
      attr_reader :http_params
      attr_reader :http_errors
      attr_reader :json_body
      attr_reader :request_id
      attr_reader :user_agent

      def initialize(message, response = nil, request_options = {})
        @message = message
        @http_headers = request_options[:headers] || {}
        @json_body = request_options[:body]

        if response
          @http_status = response.status
          @http_body = response.body
          @http_errors = response.errors
        end
      end

      def to_s
        out_message = http_status.nil? ? "" : "(Status #{http_status})\n"
        out_message += @json_body.nil? ? "" : "Raw request body: #{json_body}\n"
        unless @http_errors.nil?
          out_message += "Response Message Error/s:\n"
          @http_errors.each do |error|
            out_message += "Missing field `#{error.field}`: " if error[:field].present?
            out_message += "#{error.message}\n"
          end
        end

        out_message
      end
    end
  end
end
