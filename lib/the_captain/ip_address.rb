module TheCaptain
  class IpAddress < ApiResource
    api_path "/ip"

    def self.submit(ip, options = {})
      options = user_id_options(options)
      super
    end

    def self.delete(*_)
      raise TheCaptain.client_error(class_name, "Cannot delete a ip addresses")
    end
  end
end
