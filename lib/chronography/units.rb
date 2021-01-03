# coding: utf-8

require 'ruby-units'

Unit.redefine!("degree") do |deg|
  deg.display_name  = "°"
end

class Object

  # Shortcut for creating Unit object
  # @example
  #   Unit("1 mm")
  #   U("1 mm")
  # @return [Unit]
  def Unit(*other)
    other.to_unit
  end
  alias :U :Unit
end

Unit.define('Jyr') do |jyr|
  jyr.definition = Unit('365.25 d')
  jyr.aliases = %w[jy jyr]
  jyr.display_name = 'Jyr'
end

Unit.define("sol") do |sol|
  sol.definition   = Unit("88775 s")
  sol.aliases      = %w{sol}
  sol.display_name = "sol"
end

# Unit.define("sol") do |sol|
#   sol.definition   = Unit("24:39:35")
#   sol.aliases      = %w{sol}
#   sol.display_name = "sol"
# end

class Numeric
  def °
    Unit.new("#{self}°")
  end
  def hour
    Unit.new("#{self} h")
  end
  def d
    Unit.new("#{self} d")
  end
end

class Unit
  def sin
    Math.sin(self)
  end
  def asin
    Math.asin(self)
  end
  def cos
    Math.cos(self)
  end
  def acos
    Math.acos(self)
  end
  def tan
    Math.tan(self)
  end
  def atan
    Math.atan(self)
  end
  def circle(zeroCentric=false)
    scalar = (self % Unit.new('360.0°'))
    scalar -= 360.0 if zeroCentric && scalar > 180.0
    Unit.new("#{scalar}°")
  end
end

def UU(unit, other_unit)
  U( (unit % other_unit), other_unit.units)
end
