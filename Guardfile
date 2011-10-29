guard 'spork' do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('test/test_helper.rb')
end

guard 'minitest' do
  watch(%r|^test/test_(.*)\.rb|)
  watch(%r|^test/(.*)_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
end
