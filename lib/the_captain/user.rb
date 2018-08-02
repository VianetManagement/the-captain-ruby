# frozen_string_literal: true

module TheCaptain
  class User < APIResource
    api_paths base:        "/users/%<resource_id>s",
              payments:    "/users/%<resource_id>s/related/payments",
              ip_address:  "/users/%<resource_id>s/related/ip_addresses",
              email:       "/users/%<resource_id>s/related/email_addresses",
              content:     "/users/%<resource_id>s/related/payments",
              credit_card: "/users/%<resource_id>s/related/credit_cards"

    def self.retrieve(user_id, **params)
      request(:get, resource_id: user_id, params: params)
    end

    def self.related_payments(user_id, **params)
      request(:get, resource_id: user_id, api_dest: :payments, params: params)
    end

    def self.related_ip_addresses(user_id, **params)
      request(:get, resource_id: user_id, api_dest: :ip_address, params: params)
    end

    def self.related_email_addresses(user_id, **params)
      request(:get, resource_id: user_id, api_dest: :email, params: params)
    end

    def self.related_credit_cards(user_id, **params)
      request(:get, resource_id: user_id, api_dest: :credit_card, params: params)
    end

    def self.submit(**params)
      request(:post, api_dest: :collect, params: params)
    end
  end
end
