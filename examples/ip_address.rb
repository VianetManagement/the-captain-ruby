require_relative "base"

user1 = Faker::Number.number(12)
user2 = Faker::Number.number(12)

ip_address1 = "216.234.100.132"
ip_address2 = "206.181.8.242"

puts "Submit for signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit(ip_address1, user_id: user1, event: :user_signup))
puts JSON.pretty_generate(TheCaptain::IpAddress.submit(ip_address2, user_id: user1, event: :user_signup))


puts "Query multiple IP's at once:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve([ip_address1, ip_address2], event: :user_signup))


# puts "submit for visit"
puts JSON.pretty_generate(TheCaptain::IpAddress.submit(ip_address1, user_id: user2, event: :visit))
#
puts "Query just IP:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve(ip_address1))

puts "Query with signup:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve(ip_address1, event: :user_signup))

puts "Query with user_id:"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve(ip_address1, user_id: user1))

puts "Query with pagination (apply's to all retrieve queries)"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve(ip_address1, per: 2, page: 2))

puts "Query pagination alternative (apply's to all retrieve queries)"
puts JSON.pretty_generate(TheCaptain::IpAddress.retrieve(ip_address1, limit: 2, skip: 2))
