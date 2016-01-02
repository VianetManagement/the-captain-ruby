module TheCaptain
  class Event < ApiResource
  	include TheCaptain::APIOperations::Query

    api_path '/events'

    def self.create(event_name, event_data)
    	opts = { body: { event_name: event_name, event_data: event_data } }
    	request(method: :post, path: api_path, opts: opts)
    end
  end
end
