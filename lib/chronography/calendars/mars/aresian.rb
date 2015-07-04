require 'chronography/calendars/mars/darian'

module Chronography
  class Aresian < Darian
    # WEEK_DAYS = Gregorian::WEEK_DAYS
    WEEK_DAYS = [
      ["Soldaie",    "Sol"],
      ["Timordaie",  "Tim"],
      ["Marsdaie",   "Mar"],
      ["Wodensdaie", "Wod"],
      ["Thorsdaie",  "Tho"],
      ["Metusdaie",  "Met"],
      ["Borrsdaie",  "Bor"]
    ]
  end
end
