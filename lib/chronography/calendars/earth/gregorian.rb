require 'chronography/planets/earth'

module Chronography
  class Gregorian < Earth
    COMPONENTS = [:year, :month, :day, :hour, :minute, :second]
    EPOCH = {
      0          => [ 1970, 1, 1, 0, 0, 0 ],
      1356998400 => [ 2013, 1, 1, 0, 0, 0 ],
    }
    
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
    WEEK_DAYS = [
      ["Sunday",    "Sun"],
      ["Monday",    "Mon"],
      ["Tuesday",   "Tue"],
      ["Wednesday", "Wed"],
      ["Thursday",  "Thu"],
      ["Friday",    "Fri"],
      ["Saturday",  "Sat"]
    ]
  end
end
