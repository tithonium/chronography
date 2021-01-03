require 'utils/methodize_constants'

module Chronography
  module Calendar
    extend MethodizeConstants
    methodize_constants :months, :week_days, :month_lengths
    
    def month_length(month, year = nil)
      len = month_lengths[month-1]
      return len unless Array === len
      return len[(year && year_is_leap?(year)) ? 1 : 0]
    end
    
    {
      month: 1,
      week_day: 0,
    }.each do |method, offset|
      {:long => 0, :short => 1}.each do |prefix, idx|
        eval "def #{prefix}_#{method}s ; #{method}s.map{|x| x[#{idx}]} ; end"
        eval "def #{prefix}_#{method}(n) ; #{prefix}_#{method}s[(n - #{offset}) % num_#{method}s] ; end"
      end
    end
  end
end
