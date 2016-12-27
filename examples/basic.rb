require "the_captain"

TheCaptain.configure do |config|
  config.server_api_token = "gJSTIXixI2GTWzVd6ALuWg"
  config.site_id = "1"
  config.api_version = "v1"
  config.base_url = "http://thecaptain.elevatorup.com"
end

# # puts "Submit for signup:"
# # puts JSON.pretty_generate(TheCaptain::IpAddress.submit("216.234.127.132", user_id: 4, event: :signup))
# #
# # puts "submit for visit"
# # puts JSON.pretty_generate(TheCaptain::IpAddress.submit("216.234.127.132", user_id: 5, event: :visit))
#
# puts "Query just IP:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132"))
#
# puts "Query with signup:"
# puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", event: :signup))
#
# puts "Query with user_id:"
# puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", user_id: 4))
#
# puts "Query with pagination (apply's to all retrieve queries)"
# puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", per: 2, page: 2))
#
# puts "Query pagination alternative (apply's to all retrieve queries)"
# puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", limit: 2, skip: 2))

# If you have a User model, you can submit: user: user
puts "Submit an email"
puts JSON.pretty_generate(TheCaptain::Email.submit("user@example.com", user_id: 1))
puts JSON.pretty_generate(TheCaptain::Email.submit("user@example.com", user: 2))


puts "Query email, get lastest usage"
puts JSON.pretty_generate(TheCaptain::Email.retrieve("user@example.com"))

puts "Query email by user"
puts JSON.pretty_generate(TheCaptain::Email.retrieve("user@example.com", user: 1))
puts JSON.pretty_generate(TheCaptain::Email.retrieve("user@example.com", user: 2))
