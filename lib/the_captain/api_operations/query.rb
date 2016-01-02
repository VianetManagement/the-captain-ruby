module TheCaptain
  module APIOperations
    module Query
      # Queries a collection
      # @return [Array<TheCaptain::BaseModel>] an array of models depending on where you're calling it from (e.g. [TheCaptain::Client] from TheCaptain::Base#clients)
      def self.query(query_options = {})
      	params = TheCaptain::Util.parse_query_options(query_options)
        response = request(method: :get, path: api_path, params: params, opts: {})
        parse(response)
      end
    end
  end
end
