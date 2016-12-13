module TheCaptain
  module APIOperations
    module Read
      module ClassMethods
        # Retrieves all items
        # @return [Array<TheCaptain::BaseModel>] an array of models depending on where you're calling it from (e.g. [TheCaptain::Client] from TheCaptain::Base#clients)
        def all(params = {})
          request(method: :get, path: api_path, params: params, opts: {})
        end

        # Retrieves an item by id
        # @overload find(id)
        #   @param [Integer] the id of the item you want to retrieve
        # @overload find(id)
        #   @param [String] id the String version of the id
        # @overload find(model)
        #   @param [TheCaptain::BaseModel] id you can pass a model and it will return a refreshed version
        #
        # @return [TheCaptain::BaseModel] the model depends on where you're calling it from (e.g. TheCaptain::Client from TheCaptain::Base#clients)
        def retrieve(identifier)
          raise ArgumentError("identifier required") unless identifier
          request(method: :get, path: api_path, params: { value: identifier }, opts: {})
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
