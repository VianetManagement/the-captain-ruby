# frozen_string_literal: true

module TheCaptain
  class Content < APIResource
    api_paths base:            "content/%<resource_id>s",
              lists:           "content/%<resource_id>s/related/lists",
              payments:        "content/%<resource_id>s/related/payments",
              credit_cards:    "content/%<resource_id>s/related/credit_cards",
              email_addresses: "content/%<resource_id>s/related/email_addresses",
              ip_addresses:    "content/%<resource_id>s/related/ip_addresses"

    define_path_methods!
  end
end
