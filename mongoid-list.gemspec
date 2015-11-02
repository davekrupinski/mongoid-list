# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "mongoid/list/version"

Gem::Specification.new do |s|
  s.name          = 'mongoid-list'
  s.version       = Mongoid::List::VERSION
  s.authors       = [ 'Dave Krupinski' ]
  s.email         = 'dave@davekrupinski.com'
  s.summary       = 'Simple list behavior for Mongoid'
  s.homepage      = 'https://github.com/davekrupinski/mongoid-list'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('mongoid', '~> 5')

  s.add_development_dependency('rspec', [ '>= 3.1.0' ])
  s.add_development_dependency('guard', [ '>= 2.8.0' ])
  s.add_development_dependency('guard-rspec', [ '>= 4.2.0' ])
  s.add_development_dependency('guard-spork', [ '>= 2.0.0' ])
  s.add_development_dependency('listen', [ '>= 2.8.0' ])
end
