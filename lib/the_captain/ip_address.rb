# frozen_string_literal: true

module TheCaptain
  class IPAddress < APIResource
    api_paths base:            "ip_addresses/%<resource_id>s",
              lists:           "ip_addresses/%<resource_id>s/related/lists",
              payments:        "ip_addresses/%<resource_id>s/related/payments",
              content:         "ip_addresses/%<resource_id>s/related/content",
              credit_cards:    "ip_addresses/%<resource_id>s/related/credit_cards",
              email_addresses: "ip_addresses/%<resource_id>s/related/email_addresses"

    api_paths.each_key do |path_key|
      next if %i[base collect].include?(path_key)
      define_singleton_method("related_#{path_key}".to_sym) do |ip_address, **params|
        request(:get, resource_id: ip_address, api_dest: path_key, params: params)
      end
    end

    def self.retrieve(ip_address, **params)
      request(:get, resource_id: ip_address, params: params)
    end
  end
end
