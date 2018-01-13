# frozen_string_literal: true

class Lists < ApiResource
  api_path "/lists"

  def self.call(options = {})
    retrieve options_formatter(options) # TheCaptain::APIOperations::Crud.retrieve
  end
end
