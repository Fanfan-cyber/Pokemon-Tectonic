class Object
  # 检查某个对象是否在数组或者哈希中
  def is_in?(collection)
    case collection
    when Array
      collection.include?(self)
    when Hash
      collection.key?(self)
    else
      raise ArgumentError, "Collection must be an Array or Hash"
    end
  end
end