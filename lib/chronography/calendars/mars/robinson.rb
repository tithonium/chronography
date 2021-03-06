require 'chronography/calendars/mars/darian'
require 'chronography/calendars/earth/gregorian'

module Chronography
  class Robinson < Darian
   MONTHS = [
      ["1January",   "1Jan"],
      ["1February",  "1Feb"],
      ["1March",     "1Mar"],
      ["1April",     "1Apr"],
      ["1May",       "1May"],
      ["1June",      "1Jun"],
      ["1July",      "1Jul"],
      ["1August",    "1Aug"],
      ["1September", "1Sep"],
      ["1October",   "1Oct"],
      ["1November",  "1Nov"],
      ["1December",  "1Dec"],
      ["2January",   "2Jan"],
      ["2February",  "2Feb"],
      ["2March",     "2Mar"],
      ["2April",     "2Apr"],
      ["2May",       "2May"],
      ["2June",      "2Jun"],
      ["2July",      "2Jul"],
      ["2August",    "2Aug"],
      ["2September", "2Sep"],
      ["2October",   "2Oct"],
      ["2November",  "2Nov"],
      ["2December",  "2Dec"],
    ]
    WEEK_DAYS = Chronography::Gregorian::WEEK_DAYS
  end
end
