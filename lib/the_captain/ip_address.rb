module TheCaptain
  class IpAddress < ApiResource
    api_path "/ip"

    CONDITION_OPTIONS = {
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
      return options unless options[:condition]
      options.merge!(condition: (CONDITION_OPTIONS[options[:condition]] || options[:condition]))
    end
  end
end