$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "the_captain/version"

Gem::Specification.new do |s|
  s.name = "the_captain"
  s.version = TheCaptain::VERSION
  s.required_ruby_version = [">= 2.2.0", "< 2.4.0"]
  s.summary = "Ruby bindings for the The Captain API"
  s.description = "The Captain will tell, talk, and taddle on those pesky fraudulent scalliwags."
  s.authors = ["George Protacio-Karaszi"]
  s.email = ["george@elevatorup.com"]
  s.homepage = "https://github.com/VianetManagement/the-captain-ruby"
  s.license = "MIT"

  s.add_dependency("faraday", "~> 0.9")
  s.add_dependency("json", "~> 1.8")
  s.add_dependency("oj", "~> 2.18")
  s.add_dependency("hashie", "~> 3.5")
  s.add_dependency("typhoeus", "~> 1.1", ">= 1.1.2")
  s.add_dependency("activesupport", "~> 4.2")


  s.add_development_dependency("rake", "~> 10.4")
  s.add_development_dependency("dotenv", "~> 2.2", ">= 2.2.0")
  s.add_development_dependency("rspec", "~> 3.4")
  s.add_development_dependency("webmock", "~> 1.22")
  s.add_development_dependency("timecop", "~> 0.8.0")
  s.add_development_dependency("faker", "~> 1.8", ">= 1.8.4")
  s.add_development_dependency("byebug", "~> 8.2", ">= 8.2.1")
  s.add_development_dependency("multi_json", "~> 1.10", ">= 1.10.1")

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
