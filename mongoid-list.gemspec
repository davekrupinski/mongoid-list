# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "mongoid/list/version"

Gem::Specification.new do |s|
  s.name          = 'mongoid-list'
  s.version       = Mongoid::List::VERSION
  s.date          = '2011-10-28'
  s.authors       = [ 'Dave Krupinski' ]
  s.email         = 'dave@davekrupinski.com'
  s.summary       = 'Simple list behavior for Mongoid'
  s.homepage      = 'https://github.com/davekrupinski/mongoid-list'

  s.add_dependency('mongoid', [ '>= 2.4.0' ])

  s.add_development_dependency('bson_ext')
  s.add_development_dependency('minitest', [ '>= 2.11.0' ])
  s.add_development_dependency('mini_shoulda', [ '>= 0.4.0' ])
  s.add_development_dependency('spork', [ '>= 1.0.0.rc' ])
  s.add_development_dependency('spork-testunit', [ '>= 0.0.8' ])
  s.add_development_dependency('guard-minitest', [ '>= 0.5.0' ])
  s.add_development_dependency('guard-spork', [ '>= 0.5.2' ])
  s.add_development_dependency('turn', [ '>= 0.9.4' ])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
