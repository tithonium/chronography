# coding: utf-8

require 'defined'
Defined.enable!
require 'chronography/version'
require 'utils/methodize_constants'
require 'chronography/calendar'
require 'chronography/clock'
require 'chronography/epoch'
require 'chronography/units'

module Chronography
  class Base
    extend Calendar
    extend Clock
    include Epoch
    
    extend MethodizeConstants
    methodize_constants :day_seconds,
                        :rotation_seconds,
                        :revolution_seconds
    
    # TODO: this needs to define readers and cross-updating writers
    attr_accessor :raw_seconds
    def self.defined(*)
      self.class_eval "attr_accessor *self::COMPONENTS" if defined?(self::COMPONENTS)
    end
    
    class << self
      def now
        new(Time.now)
      end
    end
    
    def initialize(*args)
      if args.length == 1
        case args.first
        when Numeric, Time
          self.raw_seconds = args.first.to_f
        when Chronography::Base
          self.raw_seconds = args.first.raw_seconds
        end
      else
        self.class::COMPONENTS.each do |attr|
          self.send("#{attr}=", args.shift)
        end
      end
    end
    
    def to_epoch
      raw_seconds
    end
    def to_time
      Time.at(raw_seconds).utc
    end
    
    def inspect
      to_time.inspect
    end
    
    protected
    
    def hms(days)
      s = days.to('s').scalar
      d = (s / self.class.day_seconds).floor ; s -= d * self.class.day_seconds
      h = (s / self.class.hour_length).floor ; s -= h * self.class.hour_length
      m = (s / self.class.minute_length).floor   ; s -= m * self.class.minute_length
      ("%2.2d:%2.2d:%2.2d:%2.2d" % [d,h,m,s]).sub(/^00:/,'')
    end
    
  end
end

gem_root = File.dirname(__FILE__) + '/'
Dir["#{gem_root}chronography/**/*.rb"].each do |f|
  require f.sub(gem_root, '').sub(/\.rb$/,'')
end

Defined.disable!
