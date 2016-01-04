require 'spec_helper'

RSpec.describe 'Ips' do
	describe 'retrieve', :vcr do
		before{ authenticate! }

		it 'can retrieve an ip' do
			ip = TheCaptain::Ip.retrieve('126.100.200.44')
			expect(ip.ip_address).to eq('126.100.200.44')
			expect(ip.latitude).to be_present
			expect(ip.longitude).to be_present
		end
	end
end
