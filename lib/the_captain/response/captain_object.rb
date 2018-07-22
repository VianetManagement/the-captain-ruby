# frozen_string_literal: true

module TheCaptain
  module Response
    class CaptainObject < ::OpenStruct
      def method_missing(method_name, *args, &blk) # rubocop:disable Style/MissingRespondToMissing
        prefixed_method = method_name.to_s.chomp!("?")
        if prefixed_method
          @table.key?(prefixed_method.to_sym)
        else
          super
        end
      end
    end
  end
end
