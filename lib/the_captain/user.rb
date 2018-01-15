# frozen_string_literal: true

module TheCaptain
  class User < ApiResource
    api_path "/user"

    def self.call(value)
      raise_argument_error!(["value"]) if value.blank?
      retrieve(value: user_id_extract(value)) # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
