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
      super
    end

    def self.merge_options(options)
      %i(ip_address email credit_card content).each do |key|
        next unless options[key]
        raise TheCaptain::ValidationError.key_missing(class_name, key, :value) unless options[key].key?(:value)
        options[key] = "TheCaptain::#{key.to_s.classify}".constantize.merge_options(options[key])
      end
      options
    end
  end
end
