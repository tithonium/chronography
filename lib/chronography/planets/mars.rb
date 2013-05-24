require 'chronography'
require 'chronography/timeslip'

module Chronography
  class Mars < Base
    extend Timeslip
    
    DAY_SECONDS = 88775
    ROTATION_SECONDS = 88775.244
    REVOLUTION_SECONDS = 686.9725 * 86400
    
    CLOCK_SEQ = [86400, :timeslip]
  end
end
