module TheCaptain
  class Ip < ApiResource
    @api_path = '/ips'

    def self.retrieve(ip_address)
    	raise ArgumentError.new("ip_address required") unless ip_address
      response = request(method: :get, path: @api_path, params: { ip_address: ip_address }, opts: {})
      parse(response).first
    end
  end
end
