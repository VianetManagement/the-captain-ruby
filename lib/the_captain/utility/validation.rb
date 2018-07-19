# frozen_string_literal: true

module TheCaptain
  module Validation
    REQUIRED_CONTENT      = %i[ip_address email_address credit_card content].freeze
    REQUIRED_USER         = %i[user user_id session_id].freeze
    REQUIRED_LIST_FIELDS  = %i[value items].freeze
    COMBINED_REQUIREMENTS = (REQUIRED_CONTENT + REQUIRED_USER).freeze

    module_function

    def contains_any_required_fields?(options)
      unless (options.keys & COMBINED_REQUIREMENTS).any?
        raise_argument_error!(COMBINED_REQUIREMENTS)
      end
    end

    def contains_required_fields?(options)
      contains_required_content?(options)
      contains_required_user?(options)
    end

    def contains_required_content?(options)
      unless (options.keys & REQUIRED_CONTENT).any?
        raise_argument_error!(REQUIRED_CONTENT)
      end
    end

    def contains_required_user?(options)
      unless (options.keys & REQUIRED_USER).any?
        raise_argument_error!(REQUIRED_USER)
      end
    end

    def contains_required_list?(options)
      unless (options.keys & REQUIRED_LIST_FIELDS).count > 1
        raise_argument_error!(REQUIRED_LIST_FIELDS)
      end
    end

    def raise_argument_error!(fields)
      raise TheCaptain::Error::APIError.client_error(
        class_name,
        "You are required to submit one of the following fields: #{fields.join(', ')}",
      )
    end
  end
end
