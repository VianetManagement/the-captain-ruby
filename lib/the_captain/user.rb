module TheCaptain
  class User < ApiResource
    api_path "/user"

    def self.retrieve(identifier, options = {})
      identifier = user_id_extract(identifier)
      super
    end

    def self.submit(*args)
      identifier = args.first unless args.first.is_a?(Hash)
      identifier ||= args.first[:value]
      options = merge_options(args.last)
      super(identifier, options)
    end

    def self.merge_options(options)
      %i(ip_address email_address credit_card content).each do |key|
        next unless options[key]
        raise TheCaptain::ValidationError.key_missing(class_name, key, :value) unless options[key].key?(:value)
        options[key] = "TheCaptain::#{key.to_s.classify}".constantize.merge_options(options[key])
      end
      options
    end

    def self.extract_args_identifier(args)
      args.first.is_a?(Hash) ? args.first[:value] : args.first
    end
  end
end
