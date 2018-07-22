# frozen_string_literal: true

module TheCaptain
  class Stats < APIResource
    api_paths base: "/stats"

    def self.retrieve(**params)
      request(:get, params: params)
    end

    def self.retrieve_ip_address(ip_address, **params)
      merge_params!(:ip_address, ip_address, params)
      request(:get, params: params)
    end

    def self.retrieve_user(user_id, **params)
      merge_params!(:user, user_id, params)
      request(:get, params: params)
    end

    def self.retrieve_content(content, **params)
      merge_params!(:content, content, params)
      request(:get, params: params)
    end

    def self.retrieve_email_address(email_address, **params)
      merge_params!(:email_address, email_address, params)
      request(:get, params: params)
    end

    def self.merge_params!(stats_type, value, params)
      params.delete("stats_type") # Remove possible string variations
      params.delete("value")
      params.merge!(stats_type: stats_type, value: value)
    end

    def self.validate_params!(params)
      Utility::Validation.contains_required_stats?(class_name, params)
    end
  end
end
