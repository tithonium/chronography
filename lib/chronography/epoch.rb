# coding: utf-8

require 'chronography'

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
    # The currently-used standard epoch "J2000", defined by international agreement,
    # is that of 2000 January 1.5 (or January 1 at 12h on a defined time scale usually
    # TT) and is precisely defined to be
    # 
    #   1. The Julian date 2451545.0 TT (Terrestrial Time), or January 1, 2000, noon TT.
    #   2. This is equivalent to January 1, 2000, 11:59:27.816 TAI (International Atomic Time) or
    #   3. January 1, 2000, 11:58:55.816 UTC (Coordinated Universal Time).
    # 
    ### Rounding up to the next second, that's 946727936 unix epoch
    
    TAI_UTC_MAPPING_URL = 'ftp://maia.usno.navy.mil/ser7/tai-utc.dat'
    TAI_UTC_MAPPING_FILE = Gem.loaded_specs['chronography'].full_gem_path + '/config/tai-utc.dat'
    
    J2000_JD = 2451545.0
    J2000_UE = Time.at(946727936)
    
    UNIX_JD = 2440587.5
    UNIX_UE = Time.at(0)
    
    KNOWN_MIDNIGHT_JD = 2451549.5
    KNOWN_MIDNIGHT_UE = Time.at(947116800)
    
    GPS_JD = 2444244.5
    GPS_UE = Time.at(315964800)
    
    # difference between TT and TAI (TT > TAI)
    TT_TAI = 32.184
    # difference between GPS and TAI (TAI > GPS)
    GPS_TAI = -19
    
    # 
    def ΔtJ2000
      Δ = jdTT - J2000_JD
      Δ = (Δ * 100000).round.to_f / 100000.0
      # Δ.days
      Unit.new("#{Δ} days")
    end
    def jdTT
      # only valid for dates after 1 january 2009
      # ftp://maia.usno.navy.mil/ser7/tai-utc.dat
      
      st = to_time
      @offsets ||= {}
      offset = @offsets[st] ||= begin
        off = (tai_table.detect{|to| to.first <= st}.last rescue 0)
        # puts "s=#{s}  TAI-UTC=#{off}  TT-UTC=#{off + TT_TAI}"
        off
      end
      
      jdUT + (offset + TT_TAI)/86400.0
    end
    def jdUT
      UNIX_JD + (to_epoch.to_f / 86400.0) 
    end
    
    private
    
    def tai_table
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
        table = table.reverse
        table
      end
    end
    
  end
end

