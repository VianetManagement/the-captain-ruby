module TheCaptain
  module APIOperations
    module Request
      module ClassMethods
        def request(method:, path:, params: {}, opts: {})
          response = TheCaptain.request(method, path, params, opts)
          TheCaptain.last_response = response
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
