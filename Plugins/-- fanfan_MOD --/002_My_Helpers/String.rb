class String
  # 为include?增加了别名
  alias has? include?

  # 检查自身是否是数字字符串
  def number?
    self.match?(/\A[+-]?(\d+_*\d)*\.*\d+([eE][+-]?\d+)?\z/)
  end

  # 检查自身的第一个字符是否是数字
  def start_with_number?
    self.match?(/^\d/)
  end

  # 在自身末尾增加某一部分
  def add(pushing)
    "#{self}#{pushing}"
  end

  # 在自身开头增加某一部分
  def add_to_start(pushing)
    "#{pushing}#{self}"
  end

  # 将自身的符合条件的某一部分删除
  def remove(*whats)
    whats.flatten!
    whats.each do |what|
      self.gsub!("#{what}", "")
    end
    self
  end

  # 删除自身的非字母数字空格和下划线部分
  def remove_puncts
    accepted = "qwertyuiopasdfghjklzxcvbnm" + "QWERTYUIOPASDFGHJKLZXCVBNM" + "1234567890" + " _"
    ret = ""
    self.each_char do |c|
      ret += c if accepted.include?(c)
      ret += "e" if c == "é"
    end
    ret
  end

  # 删除自身的空格部分
  def unblanked
    self.gsub(" ", "")
  end

  # 将自身转换为数组
  def to_a
    [self]
  end

  # 获取xxx_xxx_xxx的左边部分
  def get_before_first(splitter)
    return "" if self.start_with?(splitter) || !self.include?(splitter)
    self.split(splitter).first
  end

  # 获取xxx_xxx_xxx的左边部分
  def get_before_last(splitter)
    return "" if self.end_with?(splitter) || !self.include?(splitter)
    self.split(splitter)[0..-2].join(splitter)
  end

  # 获取xxx_xxx_xxx的右边部分
  def get_after_first(splitter)
    return "" if self.end_with?(splitter) || !self.include?(splitter)
    self.split(splitter)[1..-1].join(splitter)
  end

  # 获取xxx_xxx_xxx的中间部分
  def get_mid(splitter)
    return "" if self.start_with?(splitter) || self.end_with?(splitter) || !self.include?(splitter)
    self.split(splitter)[1..-2].join(splitter)
  end

  # 获取xxx_xxx_xxx的最右边部分
  def get_after_last(splitter)
    return "" if self.end_with?(splitter) || !self.include?(splitter)
    self.split(splitter).last
  end

  # 检查自身是否是回文
  def palindrome?
    trimmed = self.gsub(/\W+/, "").downcase
    trimmed == trimmed.reverse
  end
end