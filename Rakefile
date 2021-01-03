require "bundler/gem_tasks"

$:.unshift File.dirname(__FILE__) + "/lib"

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

task :tick do
  require 'chronography'
  require 'awesome_print'
  loop do
    tt = Time.now
    puts
    puts "tt = #{tt.inspect} (#{tt.to_f.inspect})"
    puts "tt.utc = #{tt.utc}" if tt.respond_to?(:utc)
    t = Chronography::Aresian.new(tt)
    x = t.space
    puts " t = #{t.inspect}"
    puts " JDᵁᵀ = #{t.JDᵁᵀ.inspect}"
    puts " TT - UTC = Epoch.tai_utc(#{t.to_time.to_f.inspect})+TT_TAI = #{(Chronography::Epoch.tai_utc(t.to_time)+Chronography::Epoch::TT_TAI).inspect}"
    puts " JDᵀᵀ = #{t.JDᵀᵀ.inspect}"
    puts "⍙tʲ²⁰⁰⁰ = #{t.⍙tʲ²⁰⁰⁰.inspect}"
    ap x
    puts
    sleep 1
  end
end