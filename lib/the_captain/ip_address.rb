# frozen_string_literal: true

module TheCaptain
  class IPAddress < APIResource
    api_paths base: "",
              users: "/users",
              stats: "/stats",
              usage: "/usage"

    def retrieve(**params)
      request(:get, params: params)
    end

    def submit(**params)
      request(:post, params: params)
    end

    def retrieve_users(**params)
      request(:get, api_dest: :users, params: params)
    end

    def retrieve_stats(**params)
      request(:get, api_dest: :stats, params: params)
    end

    def retrieve_usage(**params)
      request(:get, api_dest: :usage, params: params)
    end
  end
end
