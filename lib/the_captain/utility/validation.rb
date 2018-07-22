# frozen_string_literal: true

module TheCaptain
  module Utility
    module Validation
      REQUIRED_STATS_KEYS   = %i[stats_type value].freeze
      REQUIRED_STATS_TYPE   = %i[user ip_address content email_address].freeze
      REQUIRED_CONTENT      = %i[ip_address email_address credit_card content].freeze
      REQUIRED_USER         = %i[user user_id session_id].freeze
      COMBINED_REQUIREMENTS = (REQUIRED_CONTENT + REQUIRED_USER).freeze

      module_function

      def contains_any_required_fields?(klass, options)
        unless (options.keys & COMBINED_REQUIREMENTS).any?
          raise_argument_error!(klass, COMBINED_REQUIREMENTS)
        end
      end

      def contains_required_content?(klass, options)
        unless (options.keys & REQUIRED_CONTENT).any?
          raise_argument_error!(klass, REQUIRED_CONTENT)
        end
      end

      def contains_required_user?(klass, options)
        unless (options.keys & REQUIRED_USER).any?
          raise_argument_error!(klass, REQUIRED_USER)
        end
      end

      def contains_required_stats?(klass, options)
        unless (options.keys & REQUIRED_STATS_KEYS).count == REQUIRED_STATS_KEYS.count
          raise_argument_error!(klass, REQUIRED_STATS_KEYS)
        end

        unless REQUIRED_STATS_TYPE.include?(options[:stats_type])
          raise TheCaptain::Error::ClientError.client_error(
            klass, "You must have a value that matches any of the following: #{REQUIRED_STATS_VALUES.join(', ')}"
          )
        end
      end

      def raise_argument_error!(klass, fields)
        raise TheCaptain::Error::ClientError.client_error(
          klass, "You are required to submit some of the following fields: #{fields.join(', ')}"
        )
      end
    end
  end
end
