# frozen_string_literal: true

module TheCaptain
  module Utility
    module Validation
      REQUIRED_STATS_KEYS   = %i[stats_type value].freeze
      REQUIRED_STATS_TYPE   = %i[user ip_address content email_address].freeze
      REQUIRED_CONTENT      = %i[content].freeze
      REQUIRED_USER         = %i[user user_id session_id].freeze

      module_function

      def contains_required_content?(klass, options)
        unless (options.keys & REQUIRED_CONTENT).any?
          raise_argument_error!(klass, REQUIRED_CONTENT)
        end
      end

      def valid_content_parameter?(klass, options)
        error =
          case options[:content]
          when String
            false
          when Array
            if options[:content].count > 10
              "You may only send upto 10 content pieces at any given time. Consider sending in batches instead."
            else
              options[:content].each { |content| valid_content_parameter?(klass, content: content) }
              false
            end
          else
            "Unknown content type. Content must be a String or an Array of Strings"
          end

        raise TheCaptain::Error::ClientError.client_error(klass, error) if error
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

        unless REQUIRED_STATS_TYPE.include?(options[:stats_type]&.to_sym)
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
