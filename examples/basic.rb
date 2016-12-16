require "the_captain"

TheCaptain.configure do |config|
  config.server_api_token = "gJSTIXixI2GTWzVd6ALuWg"
  config.site_id = "1"
  config.api_version = "v1"
  config.base_url = "http://thecaptain.elevatorup.com"
end

puts "Submit for signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit("216.234.127.132", user_id: 4, condition: :signup))

puts "submit for visit"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit("216.234.127.132", user_id: 5, condition: :visit))

puts "query just IP:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132"))

puts "Query with signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", condition: :signup))

puts "Query with user_id:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", user_id: 4))
