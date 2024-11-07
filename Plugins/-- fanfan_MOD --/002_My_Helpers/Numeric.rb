class Numeric
  # 数字视为非空
  def empty?
    false
  end

  # 数字视为数字
  def number?
    true
  end

  # 在数字前填充0
  def to_digits(n = 3)
    self.to_s.rjust(n, "0")
  end

  # 计算开方
  def root(n = 2)
    self ** (1.0 / n)
  end
end