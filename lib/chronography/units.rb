# coding: utf-8

require 'ruby-units'

Unit.redefine!("degree") do |deg|
  deg.display_name  = "°"
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
end

class Unit
  def sin
    Math.sin(self)
  end
  def cos
    Math.cos(self)
  end
  def circle(zeroCentric=false)
    scalar = (self % Unit.new('360.0°'))
    scalar -= 360.0 if zeroCentric && scalar > 180.0
    Unit.new("#{scalar}°")
  end
end
