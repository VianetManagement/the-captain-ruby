module TheCaptain
  class IpAddress < ApiResource
    api_path "/ip"

    EVENT_OPTIONS = {
      visit: "user:visit",
      signup: "user:signup",
      import: "user:import",
    }.freeze

    def self.retrieve(identifier, options = {})
      options = merge_options(options)
      super
    end

    def self.submit(ip, options = {})
      options = merge_options(options)
      options = user_id_options(options)
      super
    end

    def self.merge_options(options = {})
      return options unless options[:event]
      options.merge!(event: (EVENT_OPTIONS[options[:event]] || options[:event]))
    end
  end
end
