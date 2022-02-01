# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "the_captain/version"

Gem::Specification.new do |spec|
  spec.name          = "the_captain"
  spec.version       = TheCaptain::VERSION
  spec.authors       = ["George J Protacio-Karaszi"]
  spec.email         = ["george@elevatorup.com"]

  spec.summary       = "Ruby bindings for the The Captain API"
  spec.description   = "The Captain will tell, talk, and taddle on those pesky fraudulent scalliwags."
  spec.homepage      = "https://github.com/VianetManagement/the-captain-ruby"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency("http", "~> 4.0")
  spec.add_dependency("oj", "~> 3.0")

  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("rspec", "~> 3.4")
  spec.add_development_dependency("rspec-its", "~> 1.2")
end
