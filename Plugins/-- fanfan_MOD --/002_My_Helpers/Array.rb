class Array
  alias_method :random,     :sample
  alias_method :choose,     :values_at

  def each_with_index_and_object(initial_object)
    each_with_index do |element, index|
      yield(element, index, initial_object)
    end
    initial_object
  end

  def shared?(other_array)
    any? { |element| other_array.include?(element) }
  end

  def number?
    all? { |element| element.is_a?(Numeric) }
  end

  def nested?
    any? { |element| element.is_a?(Array) }
  end

  def pure?
    none? { |element| element.is_a?(Array) }
  end

  def dup?
    length != uniq.length
  end

  def drop_first(n = 1)
    drop(n)
  end

  def drop_last(n = 1)
    return self if n <= 0
    self[0..-(n + 1)]
  end

  def add(*elements, ignore: true)
    flatten_elements = elements.flatten
    if ignore
      concat(flatten_elements)
    else
      flatten_elements.each { |element| self << element if !has?(element) }
    end
    self
  end

  def add_to_start(*elements, ignore: true)
    flatten_elements = elements.flatten
    if ignore
      flatten_elements.reverse_each { |element| unshift(element) }
    else
      flatten_elements.reverse_each { |element| unshift(element) if !has?(element) }
    end
    self
  end

  def delete_random(count = 1)
    return self if empty? || count <= 0
    deleted_elements = []
    count.times do
      index = rand(length)
      deleted_elements << delete_at(index)
    end
    deleted_elements
  end

  def swap(index_1, index_2)
    new_array = dup
    new_array[index_1], new_array[index_2] = new_array[index_2], new_array[index_1]
    new_array
  end

  def swap!(index_1, index_2)
    self[index_1], self[index_2] = self[index_2], self[index_1]
    self
  end

  def move_to(index, new_index)
    return self if index < 0 || index >= length || new_index < 0
    element = self[index]
    delete_at(index)
    insert(new_index, element)
  end

  def move_to_start(index)
    return self if index < 0 || index > length
    element = self[index]
    delete_at(index)
    unshift(element)
  end

  def move_to_end(index)
    return self if index < 0 || index > length
    element = self[index]
    delete_at(index)
    add(element)
  end

  def quick_join(joiner = _INTL(", "), ender = _INTL(" and "))
    length <= 1 ? join(joiner) : "#{self[0..-2].join(joiner)}#{ender}#{self[-1]}"
  end

  def mid(mode: :random)
    mid_index = (size - 1) / 2.0
    if size.odd?
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

  def average
    array = compact
    array.sum / array.size.to_f
  end

  def mul(default = 1.0)
    reduce(default , :*)
  end

  def elements_count
    each_with_object(Hash.new(0)) { |element, counts| counts[element] += 1 }
  end

  def most_elements
    elements_count.select { |_element, count| count == most_elements_count }.keys
  end

  def most_element
    most_elements.sample
  end

  def most_elements_count
    elements_count.values.max
  end

  def least_elements
    elements_count.select { |_element, count| count == least_elements_count }.keys
  end

  def least_element
    least_elements.sample
  end

  def least_elements_count
    elements_count.values.min
  end

  def map_to(type, flatten = false)
    if flatten
      flatten.map! { |element| element.send(type) }
    else
      map do |element|
        element.is_a?(Array) ? element : element.send(type)
      end
    end
  end

  def map_to_sym(flatten = false)
    if flatten
      flatten.map!(&:to_sym)
    else
      map do |element|
        element.is_a?(Array) ? element : element.to_sym
      end
    end
  end

  def map_to_s(flatten = false)
    if flatten
      flatten.map!(&:to_s)
    else
      map do |element|
        element.is_a?(Array) ? element : element.to_s
      end
    end
  end

  def map_to_i(flatten = false)
    if flatten
      flatten.map!(&:to_i)
    else
      map do |element|
        element.is_a?(Array) ? element : element.to_i
      end
    end
  end

  def map_to_f(flatten = false)
    if flatten
      flatten.map!(&:to_f)
    else
      map do |element|
        element.is_a?(Array) ? element : element.to_f
      end
    end
  end

  def sort_by_chs
    sort_by { |s| Pinyin.t(s, tone: true) }
  end

  def sort_abil!
    sort_by! do |abil|
      abil.is_a?(Array) ? get_pos(abil[0], :Ability) : get_pos(abil, :Ability)
    end
  end

  def sort_item!
    sort_by! do |item|
      item.is_a?(Array) ? get_pos(item[0], :Item) : get_pos(item, :Item)
    end
  end

  def sort_move!
    sort_by! do |move|
      move.is_a?(Array) ? get_pos(move[0], :Move) : get_pos(move, :Move)
    end
  end

  def sort_pkmn!
    sort_by! do |pkmn|
      pkmn.is_a?(Array) ? get_pos(pkmn[0], :Pokemon) : get_pos(pkmn, :Pokemon)
    end
  end
end