require_relative "base"

list1 = "Cool List"
list2 = "Bad List"
items = ["sheeple", "my people", "tall steeples"]

puts "Submit for a new list:"
puts JSON.pretty_generate(TheCaptain::List.submit(list1, items: items))
puts JSON.pretty_generate(TheCaptain::List.submit(list2, items: items))

puts "Retrieve a list:"
puts JSON.pretty_generate(TheCaptain::List.retrieve(list1))

puts "Retrieve multiple lists"
puts JSON.pretty_generate(TheCaptain::Lists.retrieve)
