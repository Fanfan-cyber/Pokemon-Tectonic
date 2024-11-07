class Integer
  def to_a
    [self]
  end

  # 获取两个数之间的中点
  def midpoint(other_int)
    (self + other_int) / 2
  end

  def quot(div)
    (self / div).floor
  end

  def rem(div)
    [quot(div), self % div]
  end

  def remove_rem(div)
    quot(div) * div
  end
end