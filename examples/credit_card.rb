require_relative "base"

user           = Faker::Number.number(12)
cc_fingerprint = SecureRandom.hex(16)

puts "CreditCard submit:"
puts JSON.pretty_generate(TheCaptain::CreditCard.submit(cc_fingerprint, ip_address: "206.181.8.242", user_id: user, event: :success))

puts "CreditCard query:"
puts JSON.pretty_generate(TheCaptain::CreditCard.retrieve(cc_fingerprint))

puts "CreditCard query event:"
puts JSON.pretty_generate(TheCaptain::CreditCard.retrieve(cc_fingerprint, event: :success))
