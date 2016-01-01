require "the_captain"

TheCaptain.configure do |config|
  config.server_api_token = 'gJSTIXixI2GTWzVd6ALuWg'
  config.site_id = '1'
  config.api_version = 'v1'
  config.base_url = 'https://api.thecaptain.elevatorup.com'
end

## Create An Event
TheCaptain::Event.create('user.signup', {
	user_id: 'foo_bar_1',
	session_id: '234jasdfjio34234',
	ip_address: '127.0.0.1',
	user_email: 'foo.bar@example.com',
	name: 'foo bar',
	phone: '616-123-4567'
})

## Retrieve an IP
ip = TheCaptain::Ip.retrieve('127.0.0.1')
