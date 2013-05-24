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
