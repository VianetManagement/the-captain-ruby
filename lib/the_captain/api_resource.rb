module TheCaptain
  class ApiResource < Hashie::Mash
    include TheCaptain::Model
    include TheCaptain::APIOperations::Crud

    REQUIRED_CONTENT      = %i(ip_address email_address credit_card content).freeze
    REQUIRED_USER         = %i(user user_id session_id).freeze
    REQUIRED_LIST_FIELDS  = %i(value items).freeze
    COMBINED_REQUIREMENTS = (REQUIRED_CONTENT + REQUIRED_USER).freeze

    class << self
      def class_name
        name.split("::")[-1]
      end

      # Runs the options parameter through all option formatters. And returns the newly formatted options variable
      def options_formatter(options)
        options = event_options(options)
        options = pagination_options(options)
        options = user_id_options(options)
        options = time_options(options)
        items_options(options)
      end

      # Replace any underscores to a collin format ex: user_signup => user:signup
      def event_options(options)
        return options if options.nil? || options[:event].blank?
        event = options[:event].to_s.tr("_", ":")
        options.merge!(event: event)
      end

      # Tries to resolve the user id
      def user_id_options(options)
        user = options.delete(:user)
        return options if user.blank?
        options.merge!(user_id: user_id_extract(user))
      end

      # Extracts the ID of the given model or returns itself
      def user_id_extract(user)
        user.respond_to?(:id) ? user.id : user
      end

      # Convert kasmair pagination into geo4 params
      def pagination_options(options)
        options[:limit] = options.delete(:per) if options[:per]
        options[:skip]  = options.delete(:page) if options[:page]
        options
      end

      # Converts standard DateTime to millisecond's format
      def time_options(options)
        options[:from] = milliseconds(options[:from]) if options[:from]
        options[:to]   = milliseconds(options[:to]) if options[:to]
        options
      end

      def milliseconds(time)
        (time.to_f * 1000).to_i
      end

      # Ensure items is an array type of object being sent
      def items_options(options)
        return options if options[:items].blank?
        options[:items] = [options[:items]] unless options[:items].is_a?(Array)
        options
      end

      private

      # Local validation requirements

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
        raise TheCaptain::APIError.client_error(
          class_name,
          "You are required to submit one of the following fields: #{fields.join(', ')}",
        )
      end
    end
  end
end
