module TheCaptain
  class EmailAddress < ApiResource
    api_path "/email"

    def self.submit(email, options = {})
      options = user_id_options(options)
      raise ArgumentError, "user or user_id is required" unless options[:user_id]
      super
    end

    # Stub
    def self.merge_options(options)
      options
    end
  end
end
