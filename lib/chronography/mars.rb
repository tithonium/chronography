require 'chronography'
require 'chronography/timeslip'

module Chronography
  class Mars < Base
    extend Timeslip
    SECONDS_IN_DAY = 88775
  end
end
