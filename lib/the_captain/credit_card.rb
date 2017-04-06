module TheCaptain
  class CreditCard < ApiResource
    api_path "/creditcard"

    def self.submit(cc_fingerprint, options = {})
      options = user_id_options(options)
      raise ArgumentError("user or user_id required") unless options[:user_id]
      super
    end

    def self.delete(*_)
      raise TheCaptain.client_error(class_name, "Cannot delete a credit cards")
    end
  end
end
