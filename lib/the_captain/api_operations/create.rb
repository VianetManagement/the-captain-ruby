module TheCaptain
  module ApiOperations
    module Create
      module ClassMethods
        # Creates an item
        # @param [TheCaptain::BaseModel] model the item you want to create
        def create(model)
          response = request(method: :post, path: api_model.api_path.to_s, opts: { body: model })
          retrieve(response.id)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
