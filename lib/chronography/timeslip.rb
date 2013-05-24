module Chronography
  module Timeslip
    def self.extended(base)
      base.send(:include, ClassMethods)
    end
    
    module ClassMethods
      def seconds_of_day
        (self.hours * self.class.hour_length) +
        (self.minutes * self.class.minute_length) +
         self.seconds
      end
    end
  end
end
