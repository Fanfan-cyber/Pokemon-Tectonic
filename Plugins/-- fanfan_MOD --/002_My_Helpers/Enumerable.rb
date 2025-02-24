module Enumerable
  alias_method :has?,      :include?
  alias_method :includes?, :include?
  alias_method :contain?,  :include?
  alias_method :contains?, :include?

  def remove(*items)
    items.flatten.each { |item| delete(item) }
  end
end