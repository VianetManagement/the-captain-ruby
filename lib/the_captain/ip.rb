module TheCaptain
  class Ip < ApiResource
    api_path '/ips'

    def find(ip_address)
    	raise ArgumentError.new("ip_address required") unless ip_address
      response = request(:get, path: api_model.api_path, params: { ip_address: ip_address })
      api_model.parse(response).first
    end
  end
end
