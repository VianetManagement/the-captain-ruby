# frozen_string_literal: true

module TheCaptain
  class Submit < ApiResource
    api_path ""

    def self.data(options = {})
      contains_required_fields?(options)
      submit options_formatter(options) # TheCaptain::APIOperations::Crud.submit
    end
  end
end
