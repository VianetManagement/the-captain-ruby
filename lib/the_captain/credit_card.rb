# frozen_string_literal: true

module TheCaptain
  class CreditCard < APIResource
    api_paths base:            "credit_cards/%<resource_id>s",
              lists:           "credit_cards/%<resource_id>s/related/lists",
              payments:        "credit_cards/%<resource_id>s/related/payments",
              content:         "credit_cards/%<resource_id>s/related/content",
              ip_addresses:    "credit_cards/%<resource_id>s/related/ip_addresses",
              email_addresses: "credit_cards/%<resource_id>s/related/email_addresses"

    define_get_path_methods!
  end
end
