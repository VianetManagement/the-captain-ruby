module TheCaptain
  module ApiOperations
    module Create
      # Creates an item
      # @param [TheCaptain::BaseModel] model the item you want to create
      def create(model)
        model = api_model.wrap(model)
        opts = { body: model.to_json }
        response = request(method: :post, path: "#{api_model.api_path}", opts: opts)
        id = api_model.parse(response.parsed_response).first.id
        find(id)
      end
    end
  end
end
