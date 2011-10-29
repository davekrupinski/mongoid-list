require 'rake/testtask'

spec = Gem::Specification.load("mongoid-list.gemspec")

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc "Run tests"
task :default => :test
