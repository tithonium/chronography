require 'chronography/earth'

module Chronography
  class Gregorian < Earth
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
