# frozen_string_literal: true

module TheCaptain
  class ApiResource < Hashie::Mash
    include TheCaptain::Model
    include TheCaptain::APIOperations::Crud

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
        return options if options.blank? || options[:event].blank?
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
    end
  end
end
