module TheCaptain
  class Ip < ApiResource
    api_path "/ips"

    def self.retrieve(ip_address)
      raise ArgumentError.new("ip_address required") unless ip_address
      request(method: :get, path: api_path, params: { ip_address: ip_address }, opts: {})
    end
  end
end
