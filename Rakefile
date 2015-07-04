require "bundler/gem_tasks"

task :console do
  require 'irb'
  require 'chronography'
  ARGV.clear
  IRB.start
end

task :spec do
  system "rspec #{Dir['spec/**/*_spec.rb'].join(" ")} --format doc"
end

task :update_tai do
  require 'chronography/epoch'
  system %Q[curl '#{Chronography::Epoch::TAI_UTC_MAPPING_URL}' -o '#{Chronography::Epoch::TAI_UTC_MAPPING_FILE}']
end
