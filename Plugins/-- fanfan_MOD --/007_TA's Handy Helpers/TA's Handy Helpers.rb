module Enumerable
  alias has? include?
  alias includes? include?
  alias contains? include?
end

class Array
  alias random sample

  def swap(index_1, index_2)
    new = self.clone
    new[index_1], new[index_2] = new[index_2], new[index_1]
    new
  end

  def swap!(index_1, index_2)
    self[index_1], self[index_2] = self[index_2], self[index_1]
    self
  end

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

  def average
    total = self.compact.sum
    total / self.compact.size.to_f
  end

  def elements_count
    self.each_with_object(Hash.new(0)) { |element, counts| counts[element] += 1 }
  end

  def most_elements
    elements_count.select { |_element, count| count == most_elements_count }.keys
  end

  def most_elements_count
    elements_count.values.max
  end

  def least_elements
    elements_count.select { |_element, count| count == least_elements_count }.keys
  end

  def least_elements_count
    elements_count.values.min
  end
end

class Hash
  def set_values_to(new_value)
    self.dup.transform_values! { new_value }
  end

  def set_values_to!(new_value)
    self.transform_values! { new_value }
  end

  def sorted_keys
    self.sort_by { |_key, value| value }.map(&:first)
  end

  def sorted_keys_reverse
    self.sort_by { |_key, value| -value }.map(&:first)
  end

  def sorted_values
    self.values.sort
  end

  def sorted_values_reverse
    sorted_values.reverse
  end

  def highest_keys
    self.select { |_key, value| value == highest_value }.keys
  end

  def highest_value
    self.values.max
  end

  def lowest_keys
    self.select { |_key, value| value == lowest_value }.keys
  end

  def lowest_value
    self.values.min
  end
end

class Numeric
  def to_digits(n = 3)
    self.to_s.rjust(n, '0')
  end

  def root(n = 2)
    self ** (1.0 / n)
  end
end