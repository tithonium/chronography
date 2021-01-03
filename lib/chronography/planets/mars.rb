# coding: utf-8

require 'chronography'
require 'chronography/timeslip'

module Chronography
  class Mars < Base
    extend Timeslip

    DAY_SECONDS = 88775
    ROTATION_SECONDS = 88775.244
    REVOLUTION_SECONDS = 686.9725 * 86400

    SOLAR_ROTATION_PERIOD_IN_DAYS = 1.0274912517
    # SOLAR_ROTATION_PERIOD_IN_DAYS = 1.02748842592593  # where the hell did I get this?
    SIDEREAL_ROTATION_PERIOD_IN_DAYS = 1.025956748

    CLOCK_SEQ = [86400, :timeslip]

    DEFAULT_FORMAT = '%YYY-%MM-%DD %hh:%mm:%ss'

    Zero =    {:lon => 0.°,             :lat => 0.°}
    Spirit =  {:lon => 184.702.°,       :lat => -14.640.°}
    Mie =     {:lon => (360.0-139.6).°, :lat => 48.1.°}
    Airy0 =   {:lon => 0.°,             :lat => (-5.2).°}
    Olympus = {:lon => 134.°,           :lat => (18.4).°}
    Pavonis = {:lon => 113.4.°,         :lat => (0.8).°}

    class << self

      def solar_day
        SOLAR_ROTATION_PERIOD_IN_DAYS * JDay
      end

      def sidereal_day
        SIDEREAL_ROTATION_PERIOD_IN_DAYS * JDay
      end

    end

    # Perihelion Date (mean element)
    # tᵖ = 2451507.96

    # Areocentric longitude of Perihelion
    Lˢᵖ = 250.999.°

    # Anomalistic year (perihelion-to-perihelion)
    Yearᵃⁿᵒᵐ = 686.9951 * JDay
    # Yearᵃⁿᵒᵐ = 668.6141 * Sol

    # Tropical year (fictitious mean sun)
    # Yearᵗʳᵒᵖ = 1.880828 * JY_DAYS * JDay
    Yearᵗʳᵒᵖ = 686.9726 * JDay
    # Yearᵗʳᵒᵖ = 668.5941 * Sol

    COMMON_YEAR_LENGTH = 668
    LEAP_YEAR_LENGTH = 669

    # Alison/McEwen 2000 eq16
    def M
      @_M ||= (19.3870.° + 0.52402075.° / JDay * ⍙tʲ²⁰⁰⁰).circle
    end

    # Alison/McEwen 2000 eq17
    def αᶠᵐˢ
      @_αᶠᵐˢ ||= (270.3863.° + 0.52403840.° / JDay * ⍙tʲ²⁰⁰⁰ - 4e-13.° / JDay ** 2 * ⍙tʲ²⁰⁰⁰ ** 2 ).circle
    end

    # clearly not Alison/McEwen 2000 eq18. This has more precision. ?!?
    def PBS
      @_PBS ||= begin
        degPerYear = 360.0.°/365.25
        [
          { :A => 0.0071.°, :τ => U( "2.2353 d"), :Φ =>  49.409.° }, # Jupiter
          { :A => 0.0057.°, :τ => U( "2.7543 d"), :Φ => 168.173.° }, # Jupiter
          { :A => 0.0039.°, :τ => U( "1.1177 d"), :Φ => 191.837.° }, # Jupiter
          { :A => 0.0037.°, :τ => U("15.7866 d"), :Φ =>  21.736.° }, # Earth
          { :A => 0.0021.°, :τ => U( "2.1354 d"), :Φ =>  15.704.° }, # Earth
          { :A => 0.0020.°, :τ => U( "2.4694 d"), :Φ =>  95.528.° }, # Earth
          { :A => 0.0018.°, :τ => U("32.8493 d"), :Φ =>  49.095.° }, # Venus
        ].inject(0) {|s,i|
          s + i[:A] * ( ( degPerYear * ⍙tʲ²⁰⁰⁰ / i[:τ] ) + i[:Φ] ).cos
        }
      end
    end

    # EOC = ν - M
    # (ν - M) = (10.691° + 3e-7° * ⍙tʲ²⁰⁰⁰ ) * M.sin +
    #             0.623° * (2 * M).sin +
    #             0.050° * (3 * M).sin +
    #             0.005° * (4 * M).sin +
    #             0.0005° * (5 * M).sin +
    #           PBS
    def EOC # Allison/McEwen eq19, via Allison
      @_EOC ||= begin
        (
          (10.6910.° + 3e-7.° / JDay * ⍙tʲ²⁰⁰⁰) * self.M.sin +
          ( 0.6230.° * (2 * self.M).sin) +
          ( 0.0500.° * (3 * self.M).sin) +
          ( 0.0050.° * (4 * self.M).sin) +
          ( 0.0005.° * (5 * self.M).sin) +
          self.PBS
        ).circle
      end
    end
    alias :ν_minus_M :EOC

    def ν
      self.EOC + self.M
    end

    # Lˢ ≣ αᶠᵐˢ + (ν - M) # Allison
    def Lˢ
      @_Lˢ ||= (self.αᶠᵐˢ + self.EOC).circle
    end

    # EOT = αᶠᵐˢ - αˢ # Allison/McEwen eq20
    def EOT°
      @_EOT = ( (2.861.° * (2 * self.Lˢ).sin) -
                (0.071.° * (4 * self.Lˢ).sin) +
                (0.002.° * (6 * self.Lˢ).sin) -
                self.EOC ).circle(:zero)
    end
    def EOTʰ
      ( self.EOT° * Sol / 360.° ) >> 'h'
    end

    # Mean Solar Day at Prime Meridian (Airy0)
    # The addition of the integer number 44796 assures a positive result for any date since JD 2405522
    # (1873 December 29.5). More signicantly, the interval between these dates,
    # (2451549.5􏰂 - 2405522.0)d = 46027.5d = 44796.002sol, represents not only a near
    # half-day/sol commensurability, but also a very near orbit-period commensurability of
    # JY2000.012 - 􏰂JY1873.996 = 126.016Jyr = 67.0005 Mars tropical revolutions (approximately 59 synodic periods).
    # adjust the zero value to the epoch Lˢ0
    # Telescopic epoch:
    # 1609 March 11 12:21:10  JD 2308805.014699074 => 2405522 - 2308805.014699074 = 96716.985300926 d = 94129.51315122507 sol
    def MSDᵖᵐ
      (( self.JDᵀᵀ - KNOWN_MIDNIGHT_JD ) / SOLAR_ROTATION_PERIOD_IN_DAYS + 44796.0 - 0.0009626 + 94128) * Sol
    end

    # Mean Solar Time at Prime Meridian (Airy0)
    # Given in fractions of a Sol
    def MSTᵖᵐ
      UU(self.MSDᵖᵐ, Sol)
    end
    alias :meridian_mean_solar_time :MSTᵖᵐ

    # Local Mean Solar Time
    def LMST ᴧ
      ᴧ = ᴧ.° unless Unit === ᴧ
      UU(self.MSTᵖᵐ - (ᴧ * Sol / 360.°), Sol)
    end
    alias :local_mean_solar_time :LMST

    # Local True Solar Time
    # LTST = ( MST - Λᵂ * ( 24h / 360° ) + EOT * (1h/15°) ) % 24h
    # LTST = LMST + EOT * (1h/15°)
    def LTST ᴧ
      UU(self.LMST(ᴧ) + (self.EOT° * Sol / 360.°), Sol)
    end
    alias :local_true_solar_time :LTST

    def MTC
      UU(self.LMST(Mie[:lon]), Sol)
    end
    alias :martian_coordinated_time :MTC

    # Subsolar Longitude
    def Λˢ
      ( ( ( self.MSTᵖᵐ + self.EOTʰ ) * (360.° / Sol) ) + 180.° ).circle
    end
    alias :subsolar_longitude :Λˢ

    def day_of_year
      ( self.Lˢ * Yearᵗʳᵒᵖ / 360.° ) / Sol
    end

    def year_is_leap?
      self.class.year_is_leap?(self.year)
    end

    def self.year_is_leap?(y)
      # 0–2000  (Y − 1)\2 + Y\10 − Y\100 + Y\1000  668.5910 sols
      # 2001–4800  (Y − 1)\2 + Y\10 − Y\150  668.5933 sols
      # 4801–6800  (Y − 1)\2 + Y\10 − Y\200  668.5950 sols
      # 6801–8400  (Y − 1)\2 + Y\10 − Y\300  668.5967 sols
      # 8401–10000  (Y − 1)\2 + Y\10 − Y\600  668.5983 sols
      return true if y % 2 == 1
      if y < 0 || y > 10000
        return true if y % 500 == 0
        return false if y % 100 == 0
      elsif y <= 2000
        return true if y % 1000 == 0
        return false if y % 100 == 0
      elsif y <= 4800
        return false if y % 150 == 0
      elsif y <= 6800
        return false if y % 200 == 0
      elsif y <= 8400
        return false if y % 300 == 0
      elsif y <= 10000
        return false if y % 600 == 0
      end
      return true if y % 10 == 0
      false
    end

    def seconds_of_day
      self.MTC.convert_to('s').scalar
    end

    def hour
      (seconds_of_day / self.class.hour_length).floor
    end
    def minute
      ((seconds_of_day % self.class.hour_length) / self.class.minute_length).floor
    end
    def second
      (seconds_of_day % self.class.minute_length).floor
    end

    def space
      {
        :M     => self.M,
        :αᶠᵐˢ  => self.αᶠᵐˢ,
        :PBS   => self.PBS,
        :EOC   => self.EOC,
        :Lˢ    => self.Lˢ,
        :EOT°  => self.EOT°,
        :EOTʰ  => self.EOTʰ,
        :MSDᵖᵐ => [self.MSDᵖᵐ, self.MSDᵖᵐ >> 'sol'],
        :MSTᵖᵐ => [self.MSTᵖᵐ, hms(self.MSTᵖᵐ)],
        :LMST  => {
          :Airy0  => [self.LMST(Airy0[:lon]),  hms(self.LMST(Airy0[:lon]))],
          :Mie    => [self.LMST(Mie[:lon]),    hms(self.LMST(Mie[:lon]))],
          # :Spirit => [self.LMST(Spirit[:lon]), hms(self.LMST(Spirit[:lon]))],
        },
        :MTC   => [self.MTC, hms(self.MTC)],
        :LTST  => {
          :Airy0  => [self.LTST(Airy0[:lon]),  hms(self.LTST(Airy0[:lon]))],
          :Mie    => [self.LTST(Mie[:lon]),    hms(self.LTST(Mie[:lon]))],
          # :Spirit => [self.LTST(Spirit[:lon]), hms(self.LTST(Spirit[:lon]))],
        },
        :Λˢ    => self.Λˢ,
        :day_of_year => self.day_of_year,
        :day_of_epoch => self.day_of_epoch,
        :parts => self.parts,
        :to_s1 => self.to_s,
        :to_s2 => self.to_s('%D %MMM %YYY %hh:%mm:%ss'),
        :to_s3 => self.to_s('%D %MMMM %YYY %i:%mm:%ss %p'),
      }
    end

  end
end

Sol = Unit.new("#{Chronography::Mars::DAY_SECONDS} s")
