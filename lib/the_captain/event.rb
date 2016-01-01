module TheCaptain
  class Event < ApiResource
    api_path '/events'

    def self.create(event_name, event_data)
    	opts = { body: { event_name: event_name, event_data: event_data } }
    	request(method: :post, path: '/events', opts: opts)
    end
  end
end
