# frozen_string_literal: true

module TheCaptain
  class User < APIResource
    api_paths base:            "/users/%<resource_id>s",
              payments:        "/users/%<resource_id>s/related/payments",
              content:         "/users/%<resource_id>s/related/content",
              ip_addresses:    "/users/%<resource_id>s/related/ip_addresses",
              credit_cards:    "/users/%<resource_id>s/related/credit_cards",
              email_addresses: "/users/%<resource_id>s/related/email_addresses"

    define_get_path_methods!
  end
end
