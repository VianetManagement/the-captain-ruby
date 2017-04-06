module TheCaptain
  class User < ApiResource
    api_path "/user"

    def self.retrieve(*args)
      identifier = user_id_extract(extract_args_identifier(args))
      options = args.last.is_a?(Hash) ? args.last : {}
      super(identifier, options)
    end

    def self.submit(*args)
      identifier = user_id_extract(extract_args_identifier(args))
      options = merge_options(args.last) unless args.last.blank? || !args.last.is_a?(Hash)
      super(identifier, options)
    end

    def self.delete(*_)
      raise TheCaptain.client_error(class_name, "Cannot delete a users")
    end

    # Convert all nested attributes to their event type
    def self.merge_options(options)
      %i(ip_address email_address credit_card content).each do |key|
        next unless options[key]
        raise TheCaptain::ValidationError.key_missing(class_name, key, :value) unless options[key].key?(:value)
        options[key] = event_options(options[key])
      end
      options
    end

    def self.extract_args_identifier(args)
      args.first.is_a?(Hash) ? args.first[:value] : args.first
    end
  end
end
