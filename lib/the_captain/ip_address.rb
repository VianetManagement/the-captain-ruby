# frozen_string_literal: true

module TheCaptain
  class IPAddress < APIResource
    api_paths base:            "ip_addresses/%<resource_id>s",
              lists:           "ip_addresses/%<resource_id>s/related/lists",
              payments:        "ip_addresses/%<resource_id>s/related/payments",
              content:         "ip_addresses/%<resource_id>s/related/content",
              credit_cards:    "ip_addresses/%<resource_id>s/related/credit_cards",
              email_addresses: "ip_addresses/%<resource_id>s/related/email_addresses"

    define_get_path_methods!
  end
end
