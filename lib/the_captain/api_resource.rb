# frozen_string_literal: true

module TheCaptain
  class APIResource
    def self.class_name
      name.split("::")[-1]
    end

    def self.api_paths(**paths)
      @api_paths ||= paths.tap do |hash|
        hash[:base]    ||= ""
        hash[:collect] ||= "/collect"
      end.freeze
    end

    def self.request(method, api_dest: :base, path_id: nil, params: {})
      api_path = Utility::Helper.normalize_path(api_paths[api_dest], path_id)
      params   = Utility::Helper.normalize_params(params)

      CaptainClient.active_client.request(method, api_path, params).decode_response
    end

    private_class_method :request
  end
end
