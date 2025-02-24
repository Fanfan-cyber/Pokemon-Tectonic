class Object
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