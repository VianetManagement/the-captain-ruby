# frozen_string_literal: true

module TheCaptain
  module Response
    class CaptainContainer
      extend Forwardable
      attr_reader :raw_response, :data, :status

      def_delegators :@data, :method_missing

      def initialize(captain_response)
        raise Error::InvalidResourceError unless captain_response.is_a?(HTTP::Response)
        @raw_response = captain_response
        @status       = @raw_response.status
        @data         = Oj.load(@raw_response.to_s, mode: :compat, object_class: CaptainObject).freeze
        freeze
      end

      def valid?
        @status.success?
      end

      def invalid?
        !valid?
      end
    end
  end
end
