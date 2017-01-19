module TheCaptain
  class EmailAddress < ApiResource
    api_path "/email"

    EVENT_OPTIONS = {
      bounce_soft: "email:bounce:soft",
      bounce_hard: "email:bounce:hard",
      import: "email:import",
    }.freeze

    def self.submit(email, options = {})
      options = user_id_options(options)
      options = merge_options(options)
      raise ArgumentError, "user or user_id is required" unless options[:user_id]
      super
    end

    def self.retrieve(email, options = {})
      options = merge_options(options)
      super
    end

    def self.merge_options(options = {})
      return options unless options[:event]
      options.merge!(event: (EVENT_OPTIONS[options[:event]] || options[:event]))
    end
  end
end
