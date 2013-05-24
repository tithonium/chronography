require 'chronography/planets/mars'

module Chronography
  class Darian < Mars
    COMPONENTS = [:year, :month, :day, :hour, :minute, :second]
    EPOCH = {
      0          => [ 191, 20, 26, 16, 03, 05 ],
      1356998400 => [ 214, 17, 18, 11, 58, 43 ],
    }
    
    MONTHS = [
      ["Sagittarius", "Sag"],
      ["Dhanus",      "Dha"],
      ["Capricornus", "Cap"],
      ["Makara",      "Mak"],
      ["Aquarius",    "Aqu"],
      ["Kumbha",      "Kum"],
      ["Pisces",      "Pis"],
      ["Mina",        "Min"],
      ["Aries",       "Ari"],
      ["Mesha",       "Mes"],
      ["Taurus",      "Tau"],
      ["Rishabha",    "Ris"],
      ["Gemini",      "Gem"],
      ["Mithuna",     "Mit"],
      ["Cancer",      "Can"],
      ["Karka",       "Kar"],
      ["Leo",         "Leo"],
      ["Simha",       "Sim"],
      ["Virgo",       "Vir"],
      ["Kanya",       "Kan"],
      ["Libra",       "Lib"],
      ["Tula",        "Tul"],
      ["Scorpius",    "Sco"],
      ["Vrishika",    "Vri"]
    ]
    WEEK_DAYS = [
      ["Solis",    "Sol"],
      ["Lunae",    "Lun"],
      ["Martis",   "Mar"],
      ["Mercurii", "Mer"],
      ["Jovis",    "Jov"],
      ["Veneris",  "Ven"],
      ["Saturni",  "Sat"]
    ]
  end
end
