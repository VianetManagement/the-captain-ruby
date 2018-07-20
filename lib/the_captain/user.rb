# frozen_string_literal: true

module TheCaptain
  class User < APIResource
    api_paths base:         "/user",
              action:       "/user/action",
              stats:        "/user/stats",
              usage:        "/user/usage",
              verification: "/user/verification"

    def self.retrieve(**params)
      request(:get, params: params)
    end

    def self.submit(**params)
      request(:post, params: params)
    end

    def self.submit_action(**params)
      request(:post, api_dest: :action, params: params)
    end

    def self.submit_verification(**params)
      request(:post, api_dest: :verification, params: params)
    end

    def self.retrieve_verification(**params)
      request(:get, api_dest: :verification, params: params)
    end

    def self.retrieve_usage(**params)
      request(:get, api_dest: :usage, params: params)
    end

    def self.validate_params!(params)
      Validation.contains_required_user?(class_name, params)
    end
  end
end
