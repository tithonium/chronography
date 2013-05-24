require 'chronography'

module Chronography
  class Earth < Base
    DAY_SECONDS = 86400
    ROTATION_SECONDS = 86164.098903691
    REVOLUTION_SECONDS = 365.26 * 86400
  end
end
