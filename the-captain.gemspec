# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "the_captain/version"

Gem::Specification.new do |s|
  s.name                  = "the_captain"
  s.version               = TheCaptain::VERSION
  s.required_ruby_version = [">= 2.3.0", "< 2.6.0"]
  s.summary               = "Ruby bindings for the The Captain API"
  s.description           = "The Captain will tell, talk, and taddle on those pesky fraudulent scalliwags."
  s.authors               = ["George J Protacio-Karaszi"]
  s.email                 = ["george@elevatorup.com"]
  s.homepage              = "https://github.com/VianetManagement/the-captain-ruby"
  s.license               = "MIT"

  s.add_dependency("activesupport", ">= 4.2")
  s.add_dependency("faraday", ">= 0.9")
  s.add_dependency("hashie", ">= 3.5")

  s.add_development_dependency("rspec", "~> 3.4")

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
