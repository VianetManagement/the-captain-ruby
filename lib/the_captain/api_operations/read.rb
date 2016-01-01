module TheCaptain
  module Behavior
    module Read
      # Retrieves all items
      # @return [Array<TheCaptain::BaseModel>] an array of models depending on where you're calling it from (e.g. [TheCaptain::Client] from TheCaptain::Base#clients)
      def all(query_options = {})
        query = query_options
        response = request(:get, credentials, api_model.api_path, :query => query)
        api_model.parse(response.parsed_response)
      end

      # Retrieves an item by id
      # @overload find(id)
      #   @param [Integer] the id of the item you want to retreive
      # @overload find(id)
      #   @param [String] id the String version of the id
      # @overload find(model)
      #   @param [TheCaptain::BaseModel] id you can pass a model and it will return a refreshed version
      #
      # @return [TheCaptain::BaseModel] the model depends on where you're calling it from (e.g. TheCaptain::Client from TheCaptain::Base#clients)
      def find(id)
        raise ArgumentError.new("id required") unless id
        response = request(:get, path: "#{api_model.api_path}/#{id}")
        api_model.parse(response.parsed_response).first
      end
    end
  end
end
