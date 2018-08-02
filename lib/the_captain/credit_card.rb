# frozen_string_literal: true

module TheCaptain
  class CreditCard < APIResource
    api_paths base:            "credit_cards/%<resource_id>s",
              lists:           "credit_cards/%<resource_id>s/related/lists",
              payments:        "credit_cards/%<resource_id>s/related/payments",
              content:         "credit_cards/%<resource_id>s/related/content",
              ip_addresses:    "credit_cards/%<resource_id>s/related/ip_addresses",
              email_addresses: "credit_cards/%<resource_id>s/related/email_addresses"

    api_paths.each_key do |path_key|
      next if %i[base collect].include?(path_key)
      define_singleton_method("related_#{path_key}".to_sym) do |fingerprint, **params|
        request(:get, resource_id: fingerprint, api_dest: path_key, params: params)
      end
    end

    def self.retrieve(fingerprint, **params)
      request(:get, resource_id: fingerprint, params: params)
    end
  end
end
