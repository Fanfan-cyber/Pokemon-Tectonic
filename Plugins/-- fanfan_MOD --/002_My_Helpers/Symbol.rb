class Symbol
  # 检查自身是否是某一个符号
  def is?(is_what)
    is_what.is_a?(Symbol) ? self == is_what : false
  end

  # 检查自身是否包括某一部分
  def include?(symbol)
    self.to_s.include?(symbol.to_s)
  end
  alias has? include?

  # 将自身转换为数组
  def to_a
    [self]
  end

  # 将自身转换为整数数字
  def to_i
    self.to_s.to_i
  end

  # 将自身转换为浮点数字
  def to_f
    self.to_s.to_f
  end

  # 在自身末尾增加某一部分
  def add(pushing)
    "#{self}#{pushing}".to_sym
  end

  # 在自身开头增加某一部分
  def add_to_start(pushing)
    "#{pushing}#{self}".to_sym
  end

  # 将自身的符合条件的某一部分替换为另一部分
  def gsub(replace_what, with_what)
    self.to_s.gsub("#{replace_what}", "#{with_what}").to_sym
  end

  # 将自身的符合条件的某一部分删除
  def remove(*whats)
    self.to_s.remove(*whats).to_sym
  end

  # 获取xxx_xxx_xxx的最左边部分
  def get_left(splitter = "_")
    string = self.to_s.get_before_first(splitter)
    string.empty? ? self : string.to_sym
  end

  # 获取xxx_xxx_xxx的中间部分
  def get_mid(splitter = "_")
    string = self.to_s.get_mid(splitter)
    string.empty? ? self : string.to_sym
  end

  # 获取xxx_xxx_xxx的最右边部分
  def get_right(splitter = "_")
    string = self.to_s.get_after_last(splitter)
    string.empty? ? self : string.to_sym
  end
end