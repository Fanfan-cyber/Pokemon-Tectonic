module Enumerable
  alias_method :has?,       :include?
  alias_method :includes?,  :include?
  alias_method :contain?,   :include?
  alias_method :contains?,  :include?
  alias_method :select_map, :filter_map

  def remove(*items)
    items.flatten.each { |item| delete(item) }
  end

  def quick_sample
    selected = nil
    count = 0
    if block_given?
      each do |element|
        next unless yield(element)
        count += 1
        selected = element if rand(count) == 0
      end
    else
      each do |element|
        count += 1
        selected = element if rand(count) == 0
      end
    end
    count > 0 ? selected : nil
  end
end