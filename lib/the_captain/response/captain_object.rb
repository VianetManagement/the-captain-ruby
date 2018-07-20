# frozen_string_literal: true

module TheCaptain
  module Response
    class CaptainObject < ::OpenStruct
      ALLOWED_SUFFIX = "?"

      def initialize(hash = nil)
        super
      end

      def freeze
        @table.each_value { |val| val.is_a?(Array) ? val.each(&:freeze) : val.freeze }
        super
      end

      def method_missing(method_name, *args, &blk) # rubocop:disable Style/MissingRespondToMissing
        name, suffix = method_name_and_suffix(method_name)
        return super unless suffix == ALLOWED_SUFFIX
        @table.key?(name)
      end

      private

      def method_name_and_suffix(method_name)
        method_name = method_name.to_s
        if method_name.end_with?(ALLOWED_SUFFIX)
          [method_name[0..-2].to_sym, method_name[-1]]
        else
          [method_name[0..-1].to_sym, nil]
        end
      end
    end
  end
end
