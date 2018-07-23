# frozen_string_literal: true

module TheCaptain
  class Content < APIResource
    api_paths base: "",
              users: "/users",
              stats: "/stats",
              usage: "/usage"

    def self.retrieve(**params)
      request(:get, params: params)
    end

    def self.submit(**params)
      request(:post, params: params)
    end

    def self.retrieve_users(**params)
      request(:get, api_dest: :users, params: params)
    end

    def self.retrieve_stats(**params)
      request(:get, api_dest: :stats, params: params)
    end

    def self.retrieve_usage(**params)
      request(:get, api_dest: :usage, params: params)
    end

    def self.validate_params!(params)
      Utility::Validation.contains_required_content?(class_name, params)
      Utility::Validation.valid_content_parameter?(class_name, params)
    end
  end
end
