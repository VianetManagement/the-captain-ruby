module TheCaptain
  class EmailAddress < ApiResource
    api_path "/email"

    def self.submit(email, options = {})
      options = user_id_options(options)
      raise ArgumentError, "user or user_id is required" unless options[:user_id]
      super
    end

    def self.delete(*_)
      raise TheCaptain.client_error(class_name, "Cannot delete a emails")
    end
  end
end
