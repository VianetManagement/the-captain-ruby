# frozen_string_literal: true

require_relative "base"

user1 = Faker::Number.number(12)
user2 = Faker::Number.number(12)

ip_address1 = "216.234.100.132"
ip_address2 = "206.181.8.242"

pretty_json("Submit User 2 Email data", TheCaptain::Submit.data(ip_address: ip_address1, user: user2, metadata: { blacklisted: false }))

pretty_json("Submit User 2 Email data", TheCaptain::Submit.data(email_address: "user222@gmail.com", user: user2))
pretty_json("Submit User 2 Content data", TheCaptain::Submit.data(content: "This is a cool message user222@gmail.com", user: user2))
pretty_json("Retrieve User 2 content info", TheCaptain::Info.call(content: "This is a cool message user222@gmail.com", user: user2))

pretty_json("Submit for signup", TheCaptain::Submit.data(content: "This is a cool message user2@gmail.com", user: user2, event: :maybe_something))
pretty_json("Get Ip Address events", TheCaptain::Event.call(credit_card: "12345678", event: :purchase_failed))
pretty_json("Submit for visit", TheCaptain::Submit.data(ip_address: ip_address1, user: user2, event: :visit))
pretty_json("Retrieve IP information", TheCaptain::Info.call(content: "This is a cool message user2@gmail.com", user: user2))

pretty_json("Retrieve User information", TheCaptain::User.call(user1))
pretty_json("Retrieve All users that have used the same IP", TheCaptain::Users.call(ip_address: ip_address1))

pretty_json("Get Ip Address events", TheCaptain::Event.call(ip_address: [ip_address1, ip_address2], event: "user:signup"))
pretty_json("Get Ip Address events(network)", TheCaptain::Event.call(ip_address: ip_address1, network: true))

pretty_json("Get IP statuses", TheCaptain::Stats.call(ip_address: [ip_address1, ip_address2]))
pretty_json("Get IP Usage/s", TheCaptain::Usage.call(ip_address: [ip_address1, ip_address2]))

pretty_json("Creating a new list", TheCaptain::List.data(value: "Test List", items: %w[abc 123], metadata: { value: "here?" }))
pretty_json("Get the list", TheCaptain::List.call("Test List"))

pretty_json("Delete Item from list", TheCaptain::List.remove_item(value: "Test List", items: ["123"]))
pretty_json("Get the list after deleting an item", TheCaptain::List.call("Test List"))

pretty_json("Delete list", TheCaptain::List.remove_list("Test List"))
pretty_json("Get the list after deleting an item", TheCaptain::List.call("Test List"))
