require_relative "base"

# user1 = Faker::Number.number(12)
# user2 = Faker::Number.number(12)
#
# ip_address1 = "216.234.100.132"
# ip_address2 = "206.181.8.242"
#
# pretty_json("Submit for signup", TheCaptain::Submit.data(ip_address: ip_address1, user: user1, event: :user_signup))
# pretty_json("Submit for visit",  TheCaptain::Submit.data(ip_address: ip_address1, user: user2, event: :visit))
# pretty_json("Retrieve IP information", TheCaptain::Info.call(ip_address: ip_address1, user: user1))
#
# pretty_json("Retrieve User information", TheCaptain::User.call(user1))
# pretty_json("Retrieve All users that have used the same IP", TheCaptain::Users.call(ip_address: ip_address1))
#
# pretty_json("Get Ip Address events", TheCaptain::Event.call(ip_address: ip_address1))
# pretty_json("Get Ip Address events(network)", TheCaptain::Event.call(ip_address: ip_address1, network: true))
#
# pretty_json("Get IP statuses", TheCaptain::Stats.call(ip_address: [ip_address1, ip_address2]))
# pretty_json("Get IP Usage", TheCaptain::Usage.call(ip_address: [ip_address1, ip_address2]))

pretty_json("Creating a new list", TheCaptain::List.data(value: "Test List", items: ["abc", "123"], metadata: { value: "here?" }))
pretty_json("Get the list", TheCaptain::List.call("Test List"))

pretty_json("Delete Item from list", TheCaptain::List.remove_item(value: "Test List", items: ["123"]))
pretty_json("Get the list after deleting an item", TheCaptain::List.call("Test List"))

pretty_json("Delete list", TheCaptain::List.remove_list("Test List"))
pretty_json("Get the list after deleting an item", TheCaptain::List.call("Test List"))
