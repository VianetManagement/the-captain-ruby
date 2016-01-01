require 'spec_helper'

RSpec.describe 'Events' do
	describe 'Create an event', :vcr do
		before{ authenticate! }

		it 'can create an event' do
			response = TheCaptain::Event.create('user.signup', {
				user_id: 'foo_bar_1',
				session_id: '234jasdfjio34234',
				ip_address: Faker::Internet.ip_v4_address,
				user_email: Faker::Internet.email,
				name: Faker::Name.name,
				phone: Faker::PhoneNumber.phone_number.gsub('.', '')
			})

			expect(response.status).to eq(201)
			expect(response.body.length).to eq(0)
		end
	end
end
