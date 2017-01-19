module TheCaptain
  class Content < ApiResource
    api_path "/content"

    EVENT_OPTIONS = {
      bio: "user:bio",
      message: "user:message",
      message_sent: "user:message:sent",
      message_received: "user:message:received",
      import: "content:import",
    }.freeze

    def self.retrieve(identifier, options = {})
      options = merge_options(options)
      super
    end

    def self.submit(content_message, options = {})
      options = merge_options(options)
      options = user_id_options(options)
      raise ArgumentError("user or user_id is required") unless options[:user_id]
      super
    end

    def self.merge_options(options = {})
      return options unless options[:event]
      options.merge!(event: (EVENT_OPTIONS[options[:event]] || options[:event]))
    end
  end
end
