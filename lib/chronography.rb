# coding: utf-8

# require 'defined'
# Defined.enable!
require 'chronography/version'
require 'utils/methodize_constants'
require 'chronography/units'
require 'chronography/calendar'
require 'chronography/clock'
require 'chronography/epoch'

module Chronography
  class Base
    extend Calendar
    extend Clock
    include Epoch

    DEFAULT_FORMAT = '%YYYY-%MM-%DD %hh:%mm:%ss'

    extend MethodizeConstants
    methodize_constants :day_seconds,
                        :rotation_seconds,
                        :revolution_seconds

    # TODO: this needs to define readers and cross-updating writers
    attr_accessor :raw_seconds

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

    def to_unix_seconds
      raw_seconds
    end
    def to_time
      Time.at(to_unix_seconds).utc
    end

    def day_of_year
      raise NotImplementedError, "You must subclass Chronography::Base and implement day_of_year"
    end
    def year
      raise NotImplementedError, "You must subclass Chronography::Base and implement year"
    end
    def month
      raise NotImplementedError, "You must subclass Chronography::Base and implement month"
    end
    def day
      raise NotImplementedError, "You must subclass Chronography::Base and implement day"
    end
    def day_of_week
      raise NotImplementedError, "You must subclass Chronography::Base and implement day_of_week"
    end
    alias :wday :day_of_week

    def parts
      self.class::COMPONENTS.each_with_object({}) do |k, h|
        h[k] = self.send(k)
      end
    end

    def to_s(format = self.class::DEFAULT_FORMAT)
      # to_time.inspect
      format.dup.gsub(/%([a-zA-Z]+)/) do |m|
        fmt = $1
        case fmt
        when /^Y+$/
          "%*.*d" % [fmt.length, fmt.length, self.year]
        when 'M'
          self.month
        when 'MM'
          '%2.2d' % self.month
        when 'MMM'
          self.class.short_month(self.month)
        when 'MMMM'
          self.class.long_month(self.month)
        when 'D'
          self.day
        when 'DD'
          '%2.2d' % self.day
        when 'DDD'
          self.class.short_week_day(self.day_of_week)
        when 'DDDD'
          self.class.long_week_day(self.day_of_week)
        when 'h'
          self.hour
        when 'hh'
          '%2.2d' % self.hour
        when 'i'
          self.hour % 12
        when 'ii'
          '%2.2d' % (self.hour % 12)
        when 'p'
          self.hour % 12 == self.hour ? 'am' : 'pm'
        when 'pp'
          self.hour % 12 == self.hour ? 'AM' : 'PM'
        when 'm'
          self.minute
        when 'mm'
          '%2.2d' % self.minute
        when 's'
          self.second
        when 'ss'
          '%2.2d' % self.second
        else
          "%#{fmt}"
        end
      end
    end

    def inspect
      to_s
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
