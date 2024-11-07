class NilClass
  # nil视为空
  def empty?
    true
  end

  # nil视为非数字
  def number?
    false
  end
end