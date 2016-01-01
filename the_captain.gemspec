$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'the_captain/version'

spec = Gem::Specification.new do |s|
  s.name = 'the_captain'
  s.version = TheCaptain::VERSION
  s.required_ruby_version = '>= 2.0.0'
  s.summary = 'Ruby bindings for the The Captain API'
  s.description = 'The Captain will tell, talk, and taddle on those pesky fraudulent scalliwags.'
  s.authors = ['Casey Provost']
  s.email = ['casey@elevatorup.com']
  s.homepage = 'https://thecaptain.elevatorup.com/'
  s.license = 'MIT'

  s.add_dependency('faraday', '~> 0.9.2')
  s.add_dependency('json', '~> 1.8.3')
  s.add_dependency('oj', '~> 2.14.2')
  s.add_dependency('hashie', '~> 3.4.3')
  s.add_dependency('typhoeus')

  s.add_development_dependency('rspec', '~> 3.4.0')
  s.add_development_dependency('webmock', '~> 1.22.3')
  s.add_development_dependency('vcr', '~> 3.0.1')
  s.add_development_dependency('yard')
  s.add_development_dependency('redcarpet')
  s.add_development_dependency('rake')
  s.add_development_dependency('faker')
  s.add_development_dependency('factory_girl')
  s.add_development_dependency('byebug')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- rspec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
