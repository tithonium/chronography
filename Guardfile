# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :cli => "--color --format nested", :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| ["spec/lib/#{m[1]}_spec.rb", "spec/chronography_spec.rb"] }
  watch('spec/spec_helper.rb')  { "spec" }
end

