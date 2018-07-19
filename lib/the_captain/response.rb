# frozen_string_literal: true

module TheCaptain
  class Response
    attr_accessor :data, :status
    attr_writer :errors
    attr_reader :raw_response

    def initialize(data_response)
      @raw_response = data_response
    end

    def valid?; end
  end
end
