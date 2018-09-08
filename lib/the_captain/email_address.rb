# frozen_string_literal: true

module TheCaptain
  class EmailAddress < APIResource
    api_paths base:            "email_addresses/%<resource_id>s",
              lists:           "email_addresses/%<resource_id>s/related/lists",
              payments:        "email_addresses/%<resource_id>s/related/payments",
              content:         "email_addresses/%<resource_id>s/related/content",
              credit_cards:    "email_addresses/%<resource_id>s/related/credit_cards"

    define_get_path_methods!
  end
end
