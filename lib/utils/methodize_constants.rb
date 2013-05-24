module MethodizeConstants
  def methodize_constants *methods
    methods.each do |method|
      self.send :eval, "def #{method} ; self::#{method.to_s.upcase} ; end"
      self.send :eval, %Q[def num_#{method} ; raise NoMethodError, "undefined method 'num_#{method}' for #{self.name}" unless Array === #{method} ; #{method}.length ; end]
    end
  end
end
