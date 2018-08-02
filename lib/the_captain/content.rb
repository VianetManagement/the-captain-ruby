# frozen_string_literal: true

module TheCaptain
  class Content < APIResource
    api_paths base:            "content/%<resource_id>s",
              lists:           "content/%<resource_id>s/related/lists",
              payments:        "content/%<resource_id>s/related/payments",
              credit_cards:    "content/%<resource_id>s/related/credit_cards",
              email_addresses: "content/%<resource_id>s/related/email_addresses",
              ip_addresses:    "content/%<resource_id>s/related/ip_addresses"

    api_paths.each_key do |path_key|
      next if %i[base collect].include?(path_key)
      define_singleton_method("related_#{path_key}".to_sym) do |content, **params|
        request(:get, resource_id: content, api_dest: path_key, params: params)
      end
    end

    def self.retrieve(content, **params)
      request(:get, resource_id: content, params: params)
    end
  end
end
