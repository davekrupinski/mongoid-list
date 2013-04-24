guard 'spork', wait: 20 do
  watch('Gemfile')
end

guard :rspec, version: 2 do
  watch('spec/spec_helper.rb')            { "spec" }
  watch(%r{^spec/.+_spec\.rb})
end
