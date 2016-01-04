require "the_captain"

TheCaptain.configure do |config|
  config.server_api_token = 'gJSTIXixI2GTWzVd6ALuWg'
  config.site_id = '1'
  config.api_version = 'v1'
  config.base_url = 'https://api.thecaptain.elevatorup.com'
end

## Events
### Query Events

#### By an event property that is not equal to a given value
TheCaptain::Event.query(event_name: 'user.signup', filters: [
	{ property: 'user_id', operator: 'ne', value: 'foo_bar_1' }
])

#### By an event property that equals a given value
TheCaptain::Event.query(event_name: 'user.signup', filters: [
	{ property: 'user_id', operator: 'eq', value: 'foo_bar_1' }
])

#### In a given timeframe
TheCaptain::Event.query(
	event_name: 'user.signup',
	after: Time.now.to_i,
	before: Time.local(2016, 1, 1).to_i
)

#### Before a given time
TheCaptain::Event.count(event_name: 'user.signup', before: Time.now.to_i)

#### After a given time
TheCaptain::Event.count(event_name: 'user.signup', before: Time.local(2015, 12, 1).to_i)

### Create An Event
TheCaptain::Event.create('user.signup', {
	user_id: 'foo_bar_1',
	session_id: '234jasdfjio34234',
	ip_address: '127.0.0.1',
	user_email: 'foo.bar@example.com',
	name: 'foo bar',
	phone: '616-123-4567'
})

## Ips
### Retrieve an IP
ip = TheCaptain::Ip.retrieve('127.0.0.1')
