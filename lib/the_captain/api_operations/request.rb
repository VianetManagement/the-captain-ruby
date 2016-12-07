module TheCaptain
  module APIOperations
    module Request
      module ClassMethods
        def request(method:, path:, params: {}, opts: {})
          request_body = opts[:body]
          query = opts[:query] || {}

          response = TheCaptain.request(method, path, params, opts)
          TheCaptain.last_response = response

          request_options = {
            method: method,
            path: path,
            body: request_body,
            params: params,
            opts: opts,
          }

          response
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
