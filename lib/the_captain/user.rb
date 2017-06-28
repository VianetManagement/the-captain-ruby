module TheCaptain
  class Users < ApiResource
    api_path "/users"

    def self.call(options = {})
      contains_required_content?(options)
      retrieve options_formatter(options) # TheCaptain::APIOperations::Crud.retrieve
    end
  end

  class User < ApiResource
    api_path "/user"

    def self.call(value)
      raise_argument_error!(["value"]) if value.blank?
      retrieve(value: user_id_extract(value)) # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
