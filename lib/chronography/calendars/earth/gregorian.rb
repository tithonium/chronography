require 'chronography/planets/earth'

module Chronography
  class Gregorian < Earth
    ZERO_UE = -62135596800
    COMPONENTS = [:year, :month, :day, :hour, :minute, :second]
    EPOCH = {
      ZERO_UE    => [    1, 1, 1, 0, 0, 0 ],
      0          => [ 1970, 1, 1, 0, 0, 0 ],
      1356998400 => [ 2013, 1, 1, 0, 0, 0 ],
    }
    COMMON_YEAR_LENGTH = 365
    LEAP_YEAR_LENGTH = 366
    
    MONTHS = [
      ["January",   "Jan"],
      ["February",  "Feb"],
      ["March",     "Mar"],
      ["April",     "Apr"],
      ["May",       "May"],
      ["June",      "Jun"],
      ["July",      "Jul"],
      ["August",    "Aug"],
      ["September", "Sep"],
      ["October",   "Oct"],
      ["November",  "Nov"],
      ["December",  "Dec"],
    ]
    MONTH_LENGTHS = [
      31,       # Jan
      [28, 29], # Feb
      31,       # Mar
      30,       # Apr
      31,       # May
      30,       # Jun
      31,       # Jul
      31,       # Aug
      30,       # Sep
      31,       # Oct
      30,       # Nov
      31,       # Dec
    ]
    WEEK_DAYS = [
      ["Sunday",    "Sun"],
      ["Monday",    "Mon"],
      ["Tuesday",   "Tue"],
      ["Wednesday", "Wed"],
      ["Thursday",  "Thu"],
      ["Friday",    "Fri"],
      ["Saturday",  "Sat"]
    ]
    
    def self.year_is_leap?(year)
      Date.gregorian_leap?(year)
    end
    
  end
end
