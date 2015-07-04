# coding: utf-8

require 'chronography'
require 'chronography/timeslip'

module Chronography
  class Mars < Base
    extend Timeslip
    
    DAY_SECONDS = 88775
    ROTATION_SECONDS = 88775.244
    REVOLUTION_SECONDS = 686.9725 * 86400
    
    CLOCK_SEQ = [86400, :timeslip]
    
    Zero =    {:lon => 0.°,             :lat => 0.°}
    Spirit =  {:lon => 184.702.°,       :lat => -14.640.°}
    Mie =     {:lon => (360.0-139.6).°, :lat => 48.1.°}
    Airy0 =   {:lon => 0.°,             :lat => (-5.2).°}
    Olympus = {:lon => 134.°,           :lat => (18.4).°}
    Pavonis = {:lon => 113.4.°,         :lat => (0.8).°}
    
    # Perihelion Date (mean element)
    t_p = 2451507.96

    # Areocentric longitude of Perihelion
    L_sp = 250.98
    
    # # Anomalistic year (perihelion-to-perihelion)
    # τ_anom = U("686.9951d")
    # τ_anom = 668.6141.sols
    # 
    # # Tropical year (fictitious mean sun)
    # τ_trop = U("686.9725d")
    # τ_trop = 668.5921.sols
    # 
    # # Mars Solar Day
    # sol = 1.sol
    
    def M
      # 19.3870° + 0.52402075° t.ΔtJ2000
      @_M ||= (19.3870.° + 0.52402075.°/Sol * ΔtJ2000).circle
    end
    
    def αFMS
      @_αFMS ||= (270.3863.° + 0.52403840.°/Sol * ΔtJ2000).circle
    end
    
    def PBS
      @_PBS ||= begin
        degPerYear = 360.0.°/365.25
        [
          { :A => 0.0071.°, :τ => U( "2.2353 d"), :φ =>  49.409.° },
          { :A => 0.0057.°, :τ => U( "2.7543 d"), :φ => 168.173.° },
          { :A => 0.0039.°, :τ => U( "1.1177 d"), :φ => 191.837.° },
          { :A => 0.0037.°, :τ => U("15.7866 d"), :φ =>  21.736.° },
          { :A => 0.0021.°, :τ => U( "2.1354 d"), :φ =>  15.704.° },
          { :A => 0.0020.°, :τ => U( "2.4694 d"), :φ =>  95.528.° },
          { :A => 0.0018.°, :τ => U("32.8493 d"), :φ =>  49.095.° },
        ].inject(0) {|s,i|
          s + i[:A] * ( ( degPerYear * ΔtJ2000 / i[:τ] ) + i[:φ] ).cos
        }
      end
    end
    
    def ν_minus_M
      @_ν_minus_M ||= begin
        (
          (10.6910.° + U("0.00000030°/d") * ΔtJ2000) * self.M.sin +
          ( 0.6230.° * (2*self.M).sin) +
          ( 0.0500.° * (3*self.M).sin) +
          ( 0.0050.° * (4*self.M).sin) +
          ( 0.0005.° * (5*self.M).sin) +
          self.PBS
        ).circle
      end
    end
    
    def ν
      self.ν_minus_M + self.M
    end
    
    def Ls
      (self.αFMS + (self.ν - self.M)).circle
    end
    
    def EOT
      ls = self.Ls
      ( (2.861.° * (2*ls).sin) -
        (0.071.° * (4*ls).sin) +
        (0.002.° * (6*ls).sin) -
        ν_minus_M ).circle(:zero)
    end
    
    Sol = Unit("24:39:35")
    def MSD
      Sol * ( ( ( jdTT - KNOWN_MIDNIGHT_JD ) / 1.027491252 ) + 44796.0 - 0.00096 )
    end
    # alias
    
    def MTC
      U(self.MSD % Sol, Sol.units)
    end
    alias :martian_coordinated_time :MTC
    
    # Local Mean Solar Time
    def LMST Λ
      Λ = Λ.° unless Unit === Λ
      U((self.MTC - (Λ / 360.° * Sol)) % Sol, Sol.units)
    end
    alias :local_mean_solar_time :LMST

    # Local True Solar Time
    def LTST Λ
      U((self.LMST(Λ) + (self.EOT / 360.° * Sol)) % Sol, Sol.units)
    end
    alias :local_true_solar_time :LTST

    # Subsolar Longitude
    def Λ_S
      ((self.MTC * (360.°/Sol) + self.EOT) + 180.°).circle
      # (durationToDegrees(MTC + degreesToDuration(EOT)) + 180.°).normalize!
    end
    alias :subsolar_longitude :Λ_S
    
    
    def space
      [
        self.M,
        self.αFMS,
        self.PBS,
        self.ν_minus_M,
        self.Ls,
        self.EOT,
        self.MSD,
        self.MTC,
        hms(self.MTC),
        self.LMST(Mie[:lon]),
        hms(self.LMST(Mie[:lon])),
        self.LTST(Mie[:lon]),
        hms(self.LTST(Mie[:lon])),
        self.Λ_S,
      ]
    end
    
  end
end
