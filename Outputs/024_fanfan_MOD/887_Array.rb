class Array
  # 为sample添加了别名
  alias random sample

  # 为values_at添加了别名
  alias choose values_at

  # 数组视为非数字
  def numeric?
    false
  end

  # 检查数组里面是否包含数组
  def nested?
    self.any? { |element| element.is_a?(Array) }
  end

  # 检查数组里面是否不包含数组
  def pure?
    self.none? { |element| element.is_a?(Array) }
  end

  # 向数组中添加一个或者多个可重复或者不可重复的元素
  def add(*elements, ignore: true)
    elements.flatten!
    if ignore
      self.concat(elements)
    else
      elements.each { |element| self << element if !self.has?(element) }
    end
  end

  # 交换数组中两个元素的位置
  def swap(index_1, index_2)
    new_array = self.dup
    new_array[index_1], new_array[index_2] = new_array[index_2], new_array[index_1]
    new_array
  end

  def swap!(index_1, index_2)
    self[index_1], self[index_2] = self[index_2], self[index_1]
    self
  end

  # 获取数组中位于中间的那个元素
  def mid(mode: :random)
    mid_index = (self.size - 1) / 2.0
    if self.size.odd?
      self[mid_index.to_i]
    else
      case mode
      when :random
        mid_index = [mid_index.floor, mid_index.ceil].sample
        self[mid_index]
      when :small
        self[mid_index.floor]
      when :large
        self[mid_index.ceil]
      end
    end
  end

  # 计算数字数组的平均值
  def average
    array = self.compact
    array.sum / array.size.to_f
  end

  # 统计数组中各元素出现的次数
  def elements_count
    self.each_with_object(Hash.new(0)) { |element, counts| counts[element] += 1 }
  end

  # 获取数组中出现的次数最多的元素
  def most_elements
    self.elements_count.select { |_element, count| count == most_elements_count }.keys
  end

  # 获取数组中出现的次数最多的元素出现的次数
  def most_elements_count
    self.elements_count.values.max
  end

  # 获取数组中出现的次数最少的元素
  def least_elements
    self.elements_count.select { |_element, count| count == least_elements_count }.keys
  end

  # 获取数组中出现的次数最少的元素出现的次数
  def least_elements_count
    self.elements_count.values.min
  end

  # 将数组里面的元素转换为某一种类型
  def map_to(type, flatten = false)
    if flatten
      self.flatten.map! { |element| element.send(type) }
    else
      self.map do |element|
        element.is_a?(Array) ? element : element.send(type)
      end
    end
  end

  # 将数组里面的元素转换为符号
  def map_to_sym(flatten = false)
    if flatten
      self.flatten.map!(&:to_sym)
    else
      self.map do |element|
        element.is_a?(Array) ? element : element.to_sym
      end
    end
  end

  # 将数组里面的元素转换为字符串
  def map_to_s(flatten = false)
    if flatten
      self.flatten.map!(&:to_s)
    else
      self.map do |element|
        element.is_a?(Array) ? element : element.to_s
      end
    end
  end

  # 将数组里面的元素转换为整数数字
  def map_to_i(flatten = false)
    if flatten
      self.flatten.map!(&:to_i)
    else
      self.map do |element|
        element.is_a?(Array) ? element : element.to_i
      end
    end
  end

  # 将数组里面的元素转换为浮点数数字
  def map_to_f(flatten = false)
    if flatten
      self.flatten.map!(&:to_f)
    else
      self.map do |element|
        element.is_a?(Array) ? element : element.to_f
      end
    end
  end
end