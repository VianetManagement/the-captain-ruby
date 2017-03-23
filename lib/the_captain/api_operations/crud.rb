module TheCaptain
  module APIOperations
    module Crud
      # Extend the ClassMethods to the included model. This creating *super* call chain
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def request(method:, path:, params: {}, opts: {})
          TheCaptain.last_response = TheCaptain.request(method, path, params, opts)
        end

        def retrieve(identifier, options = {})
          raise ArgumentError, "value identifier required" unless identifier
          request(method: :get, path: api_path, params: resolve_identifier(identifier).merge!(options), opts: {})
        end

        def submit(identifier, event_data = {})
          raise ArgumentError, "value identifier required" unless identifier
          opts = { body: resolve_identifier(identifier) }
          opts[:body].merge!(event_data) unless event_data.blank?

          request(method: :post, path: api_path, opts: opts)
        end

        private

        def resolve_identifier(identifier)
          identifier.kind_of?(Array) ? { values: identifier } : { value: identifier }
        end
      end
    end
  end
end
