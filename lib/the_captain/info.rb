# frozen_string_literal: true

module TheCaptain
  class Info < ApiResource
    api_path ""

    def self.call(options = {})
      contains_any_required_fields?(options)
      retrieve options_formatter(options) # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
