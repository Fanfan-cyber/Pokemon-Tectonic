class Array
  # 为sample添加了别名
  alias random sample

  # 为values_at添加了别名
  alias choose values_at

  # 检查数组是否是数字数组
  def number?
    self.all? { |element| element.is_a?(Numeric) }
  end

  # 检查数组里面是否包含数组
  def nested?
    self.any? { |element| element.is_a?(Array) }
  end

  # 检查数组里面是否不包含数组
  def pure?
    self.none? { |element| element.is_a?(Array) }
  end

  # 检查数组中是否有重复的元素
  def dup?
    self.length != self.uniq.length
  end

  # 向数组末尾添加一个或者多个可重复或者不可重复的元素
  def add(*elements, ignore: true)
    elements.flatten!
    if ignore
      self.concat(elements)
    else
      elements.each { |element| self << element if !self.has?(element) }
    end
    self
  end

  # 向数组开头添加一个或者多个可重复或者不可重复的元素
  def add_to_start(*elements, ignore: true)
    elements.flatten!
    if ignore
      elements.reverse_each { |element| self.unshift(element) }
    else
      elements.reverse_each { |element| self.unshift(element) if !self.has?(element) }
    end
    self
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

  # 将某个索引的元素移到任意位置
  def move_to(index, new_index)
    return self if index < 0 || index >= self.length || new_index < 0
    element = self[index]
    self.delete_at(index)
    self.insert(new_index, element)
  end

  # 将某个索引的元素移到首位
  def move_to_start(index)
    return self if index < 0 || index > self.length
    element = self[index]
    self.delete_at(index)
    self.unshift(element)
  end

  # 将某个索引的元素移到末尾
  def move_to_end(index)
    return self if index < 0 || index > self.length
    element = self[index]
    self.delete_at(index)
    self.add(element)
  end

  # 快速连接数组里的所有元素
  def quick_join(joiner = ", ", ender = " and ")
    self.length <= 1 ? self.join(joiner) : "#{self[0..-2].join(joiner)}#{ender}#{self[-1]}"
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

  # 按照中文排列特性数组
  def sort_abil!
    self.sort_by! do |abil|
      abil.is_a?(Array) ? get_pos(abil[0], :Ability) : get_pos(abil, :Ability)
    end
  end

  # 按照中文排列物品数组
  def sort_item!
    self.sort_by! do |item|
      item.is_a?(Array) ? get_pos(item[0], :Item) : get_pos(item, :Item)
    end
  end

  # 按照中文排列技能数组
  def sort_move!
    self.sort_by! do |move|
      move.is_a?(Array) ? get_pos(move[0], :Move) : get_pos(move, :Move)
    end
  end

  # 按照中文排列精灵的物种数组
  def sort_pkmn!
    self.sort_by! do |pkmn|
      pkmn.is_a?(Array) ? get_pos(pkmn[0], :Pokemon) : get_pos(pkmn, :Pokemon)
    end
  end
end