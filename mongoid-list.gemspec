Gem::Specification.new do |s|
  s.name          = 'mongoid-list'
  s.version       = '0.1.1'
  s.date          = '2011-10-28'
  s.authors       = [ 'Dave Krupinski' ]
  s.email         = 'dave@davekrupinski.com'
  s.summary       = 'Simple list behavior for Mongoid'

  s.add_dependency('mongoid', [ '>= 2.0.0' ])

  s.add_development_dependency('bson_ext')
  s.add_development_dependency('minitest', [ '>= 2.7.0' ])
  s.add_development_dependency('mini_shoulda', [ '>= 0.4.0' ])
  s.add_development_dependency('spork', [ '>= 0.9.0.rc' ])
  s.add_development_dependency('spork-testunit', [ '>= 0.0.6' ])
  s.add_development_dependency('guard-minitest', [ '>= 0.4.0' ])
  s.add_development_dependency('guard-spork', [ '>= 0.3.1' ])
  s.add_development_dependency('turn', [ '>= 0.8.3' ])

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.require_path  = 'lib'
end
