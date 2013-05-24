require 'chronography/version'
require 'utils/methodize_constants'
require 'chronography/calendar'
require 'chronography/clock'

module Chronography
  class Base
    extend Calendar
    extend Clock
    
    extend MethodizeConstants
    methodize_constants :seconds_in_day
  end
end

gem_root = File.dirname(__FILE__) + '/'
Dir["#{gem_root}chronography/**/*.rb"].each do |f|
  require f.sub(gem_root, '').sub(/\.rb$/,'')
end


puts Chronography::Aresian.seconds_in_day
puts Chronography::Gregorian.long_week_day(0).inspect
puts Chronography::Aresian.long_week_day(0).inspect
puts Chronography::Darian.long_week_day(0).inspect
puts Chronography::Aresian.long_month(0).inspect
puts Chronography::Gregorian.long_month(0).inspect
