require 'chronography/planets/mars'

module Chronography
  class Darian < Mars
    ZERO_UE = -11385895164
    COMPONENTS = [:year, :month, :day, :hour, :minute, :second]
    EPOCH = {
      ZERO_UE     => [   0,  1,  1,  0,  0,  0 ],
      0           => [ 191, 20, 26, 16, 03, 05 ],
      1356998400  => [ 214, 17, 18, 11, 58, 43 ],
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
    MONTH_LENGTHS = [
      28,       # Sag
      28,       # Dha
      28,       # Cap
      28,       # Mak
      28,       # Aqu
      27,       # Kum
      28,       # Pis
      28,       # Min
      28,       # Ari
      28,       # Mes
      28,       # Tau
      27,       # Ris
      28,       # Gem
      28,       # Mit
      28,       # Can
      28,       # Kar
      28,       # Leo
      27,       # Sim
      28,       # Vir
      28,       # Kan
      28,       # Lib
      28,       # Tul
      28,       # Sco
      [27, 28], # Vri
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

    def day_of_epoch
      @day_of_epoch ||= (self.MSDᵖᵐ / Sol).to_base.scalar.to_i
    end

    def year
      return @year if @year
      begin
        approximate_year = (day_of_epoch / LEAP_YEAR_LENGTH).to_i
        sign = approximate_year < 0 ? -1 : 1

        starting_leaps = (1..approximate_year).map{|y| y * sign }.count{|y| self.class.year_is_leap?(y) }
        testing_years = (approximate_year.abs..(approximate_year.abs+5))
        testing_years = testing_years.map{|y| y * sign } if sign < 0

        offset = COMMON_YEAR_LENGTH * approximate_year + starting_leaps
        # STDERR.puts({approximate_year: approximate_year, starting_leaps: starting_leaps, offset: offset, testing_years: testing_years}.inspect)

        @year = testing_years.detect do |year|
          year_len = self.class.year_is_leap?(year) ? LEAP_YEAR_LENGTH : COMMON_YEAR_LENGTH
          @day_of_year = day_of_epoch - offset
          # STDERR.puts "?? #{year}  (#{day_of_epoch} - #{offset}) = #{@day_of_year} < #{year_len}"
          offset += year_len
          @day_of_year < year_len
        end
        # enable for calendars that don't have a year 0
        # @year += 1 if @year >= 0
      end
      @year
    end

    def day_of_year
      year unless @day_of_year
      @day_of_year
    end

    def month
      return @month if @month
      begin
        offset = 0
        @month = (1..self.class.num_months).detect do |m|
          @day = day_of_year - offset
          length_of_month = self.class.month_length(m, year)
          offset += length_of_month
          @day < length_of_month
        end
      end
      @month
    end

    def day
      month unless @day
      @day + 1
    end

    def day_of_week
      day_of_year % WEEK_DAYS.length
    end

  end
end
