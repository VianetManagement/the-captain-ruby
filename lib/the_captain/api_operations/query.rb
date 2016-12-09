module TheCaptain
  module APIOperations
    module Query
      module ClassMethods
        # Queries a collection
        # @return [Array<TheCaptain::BaseModel>] an array of models depending on where you're calling it from (e.g. [TheCaptain::Client] from TheCaptain::Base#clients)
        def query(query_options = {})
          params = TheCaptain::Util.parse_query_options(query_options)
          request(method: :get, path: "#{api_path}/query", params: { q: params }, opts: {})
        end

        def count(query_options = {})
          params = TheCaptain::Util.parse_query_options(query_options)
          request(method: :get, path: "#{api_path}/count", params: { q: params }, opts: {})
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
