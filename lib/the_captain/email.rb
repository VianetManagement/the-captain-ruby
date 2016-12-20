module TheCaptain
  class Email < ApiResource
    api_path "/email"

    def self.submit(email, options = {})
      options = user_id_options(options)
      raise ArgumentError("user is required") unless options[:user_id]
      super
    end
  end
end
