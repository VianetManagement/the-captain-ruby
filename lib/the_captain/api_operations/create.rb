module TheCaptain::APIOperations
  module Create
    module ClassMethods
      # Creates an item
      # @param [TheCaptain::BaseModel] model the item you want to create
      def create(model)
        response = request(method: :post, path: api_path, opts: { body: model })
        retrieve(response.id)
      end

      def submit(identifier, event_data = {})
        raise ArgumentError, "value identifier required" unless identifier
        opts = { body: { value: identifier }.merge!(event_data) }
        request(method: :post, path: api_path, opts: opts)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
