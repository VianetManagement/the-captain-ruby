# frozen_string_literal: true

module TheCaptain
  class APIResource
    def self.class_name
      name.split("::")[-1]
    end

    def self.api_paths(**paths)
      @api_paths ||= paths.tap { |hash| hash[:base] ||= "" }
    end

    def self.request(method, api_dest: :base, params: {})
      validate_params!(params)
      Utility::Helper.normalize_params!(params)

      CaptainClient.active_client
                   .request(method, api_paths[api_dest], params)
                   .decode_response
    end

    def self.validate_params!(_params)
      true
    end
  end
end
