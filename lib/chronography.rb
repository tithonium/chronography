require 'chronography/version'
require 'utils/methodize_constants'
require 'chronography/calendar'
require 'chronography/clock'

module Chronography
  class Base
    extend Calendar
    extend Clock
    
    extend MethodizeConstants
    methodize_constants :day_seconds,
                        :rotation_seconds,
                        :revolution_seconds
  end
end

gem_root = File.dirname(__FILE__) + '/'
Dir["#{gem_root}chronography/**/*.rb"].each do |f|
  require f.sub(gem_root, '').sub(/\.rb$/,'')
end
