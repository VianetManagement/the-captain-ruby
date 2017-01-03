require "the_captain"
require "faker"
TheCaptain.configure do |config|
  config.server_api_token = "gJSTIXixI2GTWzVd6ALuWg"
  config.site_id = "1"
  config.api_version = "v1"
  config.base_url = "http://thecaptain.elevatorup.com"
end

user1 = Faker::Number.number(12)
user2 = Faker::Number.number(12)
user3 = Faker::Number.number(12)

puts "Submit for signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit("216.234.127.132", user_id: user1, event: :signup))

puts "submit for visit"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit("216.234.127.132", user_id: user2, event: :visit))

puts "Query just IP:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132"))

puts "Query with signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", event: :signup))

puts "Query with user_id:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", user_id: user2))

puts "Query with pagination (apply's to all retrieve queries)"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", per: 2, page: 2))

puts "Query pagination alternative (apply's to all retrieve queries)"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("216.234.127.132", limit: 2, skip: 2))

# If you have a User model, you can submit: user: user
puts "Submit an email"
puts JSON.pretty_generate(TheCaptain::EmailAddress.submit("user99@example.com", user_id: user3))
puts JSON.pretty_generate(TheCaptain::EmailAddress.submit("user98@example.com", user: user3))

puts "Query email, get lastest usage"
puts JSON.pretty_generate(TheCaptain::EmailAddress.retrieve("user99@example.com"))

puts "Query email by user"
puts JSON.pretty_generate(TheCaptain::EmailAddress.retrieve("user98@example.com", user: user3))

# puts "Submit user data"

puts JSON.pretty_generate(TheCaptain::User.submit(user3,
                                                  email_address: { value: "baby99@example" },
                                                  ip_address: { value: "216.234.127.132", event: :import },
                                                  content: { value: "THIS IS BY BLOG POST", event: :bio },
                                                  credit_card: { value: "such_a_good_fingerprint", event: :import },
                                                  flag: { type: "random flag", status: "open" }))

puts JSON.pretty_generate(TheCaptain::User.retrieve(user3))
