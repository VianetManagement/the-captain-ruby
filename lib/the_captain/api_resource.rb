# frozen_string_literal: true

module TheCaptain
  class APIResource
    def self.class_name
      name.split("::")[-1]
    end

    def self.api_path(path = nil)
      @api_path ||= path
    end

    def self.request(method, api_destination: api_path, params: {})
      validate_params!(params)
      params = normalize_params!(params)
      CaptainClient.active_client.request(method, api_destination, params).decode_response
    end

    def self.validate_params!(_params)
      true
    end

    def self.normalize_params!(params)
      params
    end
  end
end
