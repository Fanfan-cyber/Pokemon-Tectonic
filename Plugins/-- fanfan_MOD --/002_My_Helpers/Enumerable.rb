module Enumerable
  # 为include?添加了一些别名
  alias has? include?
  alias contain? include?
  alias includes? include?
  alias contains? include?

  # 从数组或者哈希中删除一个或者多个元素或者键值对
  def remove(*items)
    items.flatten.each { |item| delete(item) }
  end
end