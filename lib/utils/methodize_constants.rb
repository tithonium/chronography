module MethodizeConstants
  def methodize_constants *methods
    methods.each do |method|
      self.send :eval, "def #{method} ; self::#{method.to_s.upcase} ; end"
    end
  end
end
