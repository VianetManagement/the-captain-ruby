# frozen_string_literal: true

module TheCaptain
  class Message < APIResource
    api_paths base: "/message"

    def submit(**params)
      request(:post, params: params)
    end

    def update(**params)
      request(:patch, params: params)
    end
  end
end
