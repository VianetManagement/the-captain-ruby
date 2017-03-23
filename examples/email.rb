require_relative "base"

user1 = Faker::Number.number(12)
user2 = Faker::Number.number(12)
user3 = Faker::Number.number(12)

# If you have a User model, you can submit: user: user
puts "Submit an email"
puts JSON.pretty_generate(TheCaptain::EmailAddress.submit("user#{user1}@example.com", user_id: user3, event: :bounce_hard))
puts JSON.pretty_generate(TheCaptain::EmailAddress.submit("user#{user2}@example.com", user: user3))
#
puts "Query email, get lastest usage"
puts JSON.pretty_generate(TheCaptain::EmailAddress.retrieve("user#{user1}@example.com"))
puts JSON.pretty_generate(TheCaptain::EmailAddress.retrieve("user#{user2}@example.com"))
#
puts "Query email by user"
puts JSON.pretty_generate(TheCaptain::EmailAddress.retrieve("user98@example.com", user: user3))
