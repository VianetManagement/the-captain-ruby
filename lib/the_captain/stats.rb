module TheCaptain
  class Stats < ApiResource
    api_path "/stats"

    def self.call(options = {})
      contains_required_content?(options)
      retrieve options_formatter(options) # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
