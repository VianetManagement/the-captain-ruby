module TheCaptain
  class Event < ApiResource
    api_path "/events"

    def self.call(options = {})
      contains_any_required_fields?(options)
      retrieve options_formatter(options) # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
