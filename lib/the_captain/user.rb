# frozen_string_literal: true

module TheCaptain
  class User < APIResource
    api_paths base:            "/users/%<resource_id>s",
              payments:        "/users/%<resource_id>s/related/payments",
              content:         "/users/%<resource_id>s/related/payments",
              ip_addresses:    "/users/%<resource_id>s/related/ip_addresses",
              credit_cards:    "/users/%<resource_id>s/related/credit_cards",
              email_addresses: "/users/%<resource_id>s/related/email_addresses"

    api_paths.each_key do |path_key|
      next if %i[base collect].include?(path_key)
      define_singleton_method("related_#{path_key}".to_sym) do |user_id, **params|
        request(:get, resource_id: user_id, api_dest: path_key, params: params)
      end
    end

    def self.retrieve(user_id, **params)
      request(:get, resource_id: user_id, params: params)
    end
  end
end
