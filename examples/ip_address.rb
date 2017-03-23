require_relative "base"

user1 = Faker::Number.number(12)
user2 = Faker::Number.number(12)

puts "Submit for signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit("206.181.8.242", user_id: user1, event: :user_signup))

# puts "submit for visit"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit("206.181.8.242", user_id: user2, event: :visit))
#
puts "Query just IP:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("206.181.8.242"))

puts "Query with signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("206.181.8.242", event: :user_signup))

puts "Query with user_id:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("206.181.8.242", user_id: user1))

puts "Query with pagination (apply's to all retrieve queries)"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("206.181.8.242", per: 2, page: 2))

puts "Query pagination alternative (apply's to all retrieve queries)"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve("206.181.8.242", limit: 2, skip: 2))
