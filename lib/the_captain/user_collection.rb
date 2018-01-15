# frozen_string_literal: true

module TheCaptain
  class UserCollection < ApiResource
    api_path "/users"

    def self.call(options = {})
      contains_required_content?(options)
      retrieve options_formatter(options) # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
