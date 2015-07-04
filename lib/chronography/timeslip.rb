module Chronography
  module Timeslip
    def self.extended(base)
      base.send(:include, ClassMethods)
    end
    
    module ClassMethods
      def seconds_of_day
        (self.hour * self.class.hour_length) +
        (self.minute * self.class.minute_length) +
         self.second
      end
    end
  end
end
