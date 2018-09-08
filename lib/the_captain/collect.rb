# frozen_string_literal: true

module TheCaptain
  class Collect < APIResource
    api_paths base: "collect"

    def self.submit(**params)
      request(:post, params: params)
    end
  end
end
