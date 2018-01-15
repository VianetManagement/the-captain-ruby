# frozen_string_literal: true

module TheCaptain
  class ListCollection < ApiResource
    api_path "/lists"

    def self.call(options = {})
      retrieve options_formatter(options) # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
