module TheCaptain
  module APIOperations
    module Crud
      module ClassMethods
        def self.included(base)
          base.extend(ClassMethods)
        end

        def request(method:, path:, params: {}, opts: {})
          response = TheCaptain.request(method, path, params, opts)
          TheCaptain.last_response = response
        end

        def retrieve(identifier, options = {})
          raise ArgumentError, "value identifier required" unless identifier
          request(method: :get, path: api_path, params: { value: identifier }.merge!(options), opts: {})
        end

        def submit(identifier, event_data = {})
          raise ArgumentError, "value identifier required" unless identifier

          opts = { body: { value: identifier } }
          opts[:body].merge!(event_data) unless event_data.blank?

          request(method: :post, path: api_path, opts: opts)
        end
      end
    end
  end
end
