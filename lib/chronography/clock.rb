# coding: utf-8

require 'utils/methodize_constants'

module Chronography
  module Clock
    extend MethodizeConstants
    methodize_constants :hour_length, :minute_length
    
    def self.extended(base)
      base.class_eval <<-RUBY
        HOUR_LENGTH = 3600 unless defined?(HOUR_LENGTH)
        MINUTE_LENGTH = 60 unless defined?(MINUTE_LENGTH)
      RUBY
    end
    
    # Timezone support
    
  end
end
