# frozen_string_literal: true

module TheCaptain
  class User < APIResource
    api_path "/user"

    def self.retrieve(params = {})
      request(:get, params: params)
    end

    def self.submit(params = {})
      request(:post, params: params)
    end

    def self.validate_params!(params)
      Validation.contains_required_user?(class_name, params)
    end
  end
end
