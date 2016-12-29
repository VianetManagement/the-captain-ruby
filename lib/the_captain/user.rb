module TheCaptain
  class User < ApiResource
    api_path "/user"

    def self.retrieve(identifier, options = {})
      identifier = user_id_extract(identifier)
      super
    end

    def self.submit(identifier, options = {})
      identifier = user_id_extract(identifier)
      options = merge_options(options)
      validate_options(options)
      super
    end

    def self.merge_options(options)
      if options[:ip_address]
        options[:ip_address] = IpAddress.merge_options(options[:ip_address])
      end
      if options[:email]
        options[:email] = Email.merge_options(options[:email])
      end
      if options[:credit_card]
        options[:credit_card] = CreditCard.merge_options(options[:credit_card])
      end
      if options[:content]
        options[:content] = Content.merge_options(options[:content])
      end

      options
    end


    def self.validate_options(options)
      %i(ip_address email credit_card content).each do | key |
        next unless options[key]
        raise TheCaptain::ValidationError.key_missing(class_name, key, :value) unless options[key].key?(:value)
      end
    end
  end
end
