class Hash
  # 哈希视为非数字
  def numeric?
    false
  end

  # 选择哈希中的一个或者多个键值对
  def choose(*keys)
    items.flatten!
    self.select { |key, _value| keys.has?(key) }
  end

  # 将所有键设置为某一个值
  def set_values(new_value)
    self.transform_values { new_value }
  end

  def set_values!(new_value)
    self.transform_values! { new_value }
  end

  # 获取对哈希按照值进行从小到大排序后的所有键
  def sorted_keys
    self.sort_by { |_key, value| value }.map(&:first)
  end

  # 获取对哈希按照值进行从大到小排序后的所有键
  def sorted_keys_reverse
    self.sort_by { |_key, value| -value }.map(&:first)
  end

  # 获取进行从小到大排序后的所有值
  def sorted_values
    self.values.sort
  end

  # 获取进行从大到小排序后的所有值
  def sorted_values_reverse
    self.values.sort.reverse
  end

  # 获取值最大的所有键
  def highest_keys
    self.select { |_key, value| value == highest_value }.keys
  end

  # 获取最大的值
  def highest_value
    self.values.max
  end

  # 获取值最小的所有键
  def lowest_keys
    self.select { |_key, value| value == lowest_value }.keys
  end

  # 获取最小的值
  def lowest_value
    self.values.min
  end
end