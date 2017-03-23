require_relative "base"

user = Faker::Number.number(12)

puts "Content submit:"
puts JSON.pretty_generate(TheCaptain::Content.submit("Hello World admin@example.com", user_id: user, event: :description))

puts "Content query:"
puts JSON.pretty_generate(TheCaptain::Content.retrieve("Hello World"))

puts "Content query event:"
puts JSON.pretty_generate(TheCaptain::Content.retrieve("Hello World", event: :description))

puts "Content query User:"
puts JSON.pretty_generate(TheCaptain::Content.retrieve("Hello World", user_id: user))
