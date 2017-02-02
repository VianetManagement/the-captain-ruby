module TheCaptain
  class IpAddress < ApiResource
    api_path "/ip"

    def self.submit(ip, options = {})
      options = user_id_options(options)
      super
    end
  end
end
