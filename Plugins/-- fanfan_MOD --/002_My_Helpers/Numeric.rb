class Numeric
  def to_digits(n = 3)
    to_s.rjust(n, "0")
  end

  def root(n = 2)
    self ** (1.0 / n)
  end
end