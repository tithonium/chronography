require 'utils/methodize_constants'

module Chronography
  module Calendar
    extend MethodizeConstants
    methodize_constants :months, :week_days

    [
      :month,
      :week_day,
    ].each do |method|
      {:long => :first, :short => :last}.each do |prefix, sel|
        eval "def #{prefix}_#{method}s ; #{method}s.map(&:#{sel}) ; end"
        eval "def #{prefix}_#{method}(n) ; #{prefix}_#{method}s[(n - 1) % num_#{method}s] ; end"
      end
    end
  end
end
