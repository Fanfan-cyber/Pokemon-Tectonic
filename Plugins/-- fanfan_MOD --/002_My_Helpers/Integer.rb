class Integer
  alias_method :remainder, :modulo

  def multiple_of?(number)
    self % number == 0
  end
  alias_method :divisible_by?, :multiple_of?

  def prime?
    return false if self <= 1
    return true if self == 2
    return false if even?
    3.step(Math.sqrt(self).to_i, 2) do |i|
      return false if self % i == 0
    end
    return true
  end

  def to_a
    [self]
  end

  def midpoint(other_int)
    (self + other_int) / 2
  end
end