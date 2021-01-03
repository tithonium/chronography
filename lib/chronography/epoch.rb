# coding: utf-8

# require_relative 'chronography'
require 'time'
require 'date'
require 'chronography/units'

module Chronography
  module Epoch

    # TT = Terrestrial Time
    #      http://en.wikipedia.org/wiki/Terrestrial_Time
    # UT  = Univeral Time
    # UT1 = Univeral Time at 0° longitude
    #       http://en.wikipedia.org/wiki/Universal_Time
    # UTC = Coordinated Universal Time
    #       http://en.wikipedia.org/wiki/Coordinated_Universal_Time
    # TAI = International Atomic Time
    #       http://en.wikipedia.org/wiki/International_Atomic_Time
    # GPS = GPS time
    #       http://en.wikipedia.org/wiki/GPS_time#Timekeeping

    # http://en.wikipedia.org/wiki/Julian_epoch#Julian_years_and_J2000
    #
    # The currently-used standard epoch "J²⁰⁰⁰", defined by international agreement,
    # is that of 2000 January 1.5 (or January 1 at 12h on a defined time scale usually
    # TT) and is precisely defined to be
    #
    #   1. The Julian date 2451545.0 TT (Terrestrial Time), or January 1, 2000, noon TT.
    #   2. This is equivalent to January 1, 2000, 11:59:27.816 TAI (International Atomic Time) or
    #   3. January 1, 2000, 11:58:55.816 UTC (Coordinated Universal Time).
    #
    ### That's 946727936 unix epoch

    TAI_UTC_MAPPING_URL = 'http://maia.usno.navy.mil/ser7/tai-utc.dat'
    TAI_UTC_MAPPING_FILE = Gem.loaded_specs['chronography'].full_gem_path + '/config/tai-utc.dat'

    # Seconds in a Julian Day
    JD_SECONDS = 86400.0

    # Julian Days in a Julian Year
    JY_DAYS = 365.25

    # J²⁰⁰⁰ Epoch
    # 2000 January 01 12:00:00.0 UT
    J²⁰⁰⁰_JD = 2451545.0
    J²⁰⁰⁰_UE = Time.at(946727935.816)

    # Unix Epoch
    # 1970 January 01 00:00:00.0 UT
    UNIX_JD = 2440587.5
    UNIX_UE = Time.at(0)

    # A convenient midnight near J²⁰⁰⁰ epoch that is also close to midnight at Airy-0
    # 2000 January 06 00:00:00.0 UT
    KNOWN_MIDNIGHT_JD = 2451549.5
    KNOWN_MIDNIGHT_UE = Time.at(947116800)

    # The GPS system epoch
    # 1980 January 06 00:00:00.0 UT
    GPS_JD = 2444244.5
    GPS_UE = Time.at(315964800)

    # difference between TT and TAI (TT > TAI)
    TT_TAI = 32.184
    # difference between GPS and TAI (TAI > GPS)
    GPS_TAI = -19

    # The difference between self and the J²⁰⁰⁰ in Julian Days
    # Allison/McEwen Eq15
    def ⍙tʲ²⁰⁰⁰
      @⍙tʲ²⁰⁰⁰ ||= begin
        _Δ = self.JDᵀᵀ - J²⁰⁰⁰_JD
        _Δ = (_Δ * 100000.0).round / 100000.0
        Unit.new("#{_Δ} days")
      end
    end

    # JDᵀᵀ and JDᵁᵀ derived from http://www.giss.nasa.gov/tools/mars24/help/algorithm.html
    def JDᵀᵀ
      # only valid for dates after 1 january 2009
      # ftp://maia.usno.navy.mil/ser7/tai-utc.dat

      @_JDᵀᵀ ||= begin

        offset = Epoch.tai_utc(to_time)
        # STDERR.puts "self.JDᵁᵀ=#{self.JDᵁᵀ.inspect} offset=#{offset.inspect} TT_TAI=#{TT_TAI.inspect} => #{(self.JDᵁᵀ + (offset + TT_TAI) / JD_SECONDS).inspect}"

        self.JDᵁᵀ + (offset + TT_TAI) / JD_SECONDS
      end
    end
    def JDᵁᵀ
      @_JDᵁᵀ ||= UNIX_JD + (to_unix_seconds.to_f / JD_SECONDS)
    end

    def self.tai_utc(time)
      time = Time.at(time) if time.is_a?(Integer)
      time = time.utc
      utcDate = time.to_date
      @tai_utc_offsets ||= {}
      @tai_utc_offsets[utcDate] ||= begin
        tai_utc_table.detect{|to| to.first <= time}.last rescue 0
      end
      @tai_utc_offsets[utcDate]
    end

    private

    def self.tai_utc_table
      @table ||= begin
        table = []
        open(TAI_UTC_MAPPING_FILE) do |f|
          f.each_line do |line|
            # 1980 JAN  1 =JD 2444239.5  TAI-UTC=  19.0       S + (MJD - 41317.) X 0.0      S
            if m = line.match(/(\d{4} \S{3} +\d{1,2})\s+=JD [0-9\.]+\s+TAI-UTC=\s*([0-9\.]+)\s+/)
              d = Date.parse(m[1])
              o = m[2].to_f
              d = Time.gm(d.year,d.month,d.day)
              table << [d, o]
            end
          end
        end
        table.reverse
      end
    end

  end
end

JDay = Unit.new("#{Chronography::Epoch::JD_SECONDS} s")
