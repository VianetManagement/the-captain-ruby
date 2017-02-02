module TheCaptain
  class Content < ApiResource
    api_path "/content"

    def self.submit(content_message, options = {})
      options = user_id_options(options)
      raise ArgumentError("user or user_id is required") unless options[:user_id]
      super
    end
  end
end
