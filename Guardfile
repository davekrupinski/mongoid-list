guard 'spork', wait: 20 do
  watch('Gemfile')
end

guard :rspec, cmd: "bundle exec rspec" do
  watch('spec/spec_helper.rb')    { "spec" }
  watch(%r{^lib/(.+)\.rb$})       { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/.+_spec\.rb})
end
