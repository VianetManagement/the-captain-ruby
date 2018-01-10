# frozen_string_literal: true

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

        def retrieve(options = {})
          request(method: :get, path: api_path, params: options, opts: {})
        end

        def submit(options = {})
          opts = { body: options }
          request(method: :post, path: api_path, opts: opts)
        end

        def delete(options = {})
          opts = { body: options }
          request(method: :delete, path: api_path, opts: opts)
        end
      end
    end
  end
end
