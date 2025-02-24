class Symbol
  def is?(is_what)
    is_what.is_a?(Symbol) ? self == is_what : false
  end

  def include?(symbol)
    to_s.include?(symbol.to_s)
  end
  alias has? include?

  def to_a
    [self]
  end

  def to_i
    to_s.to_i
  end

  def to_f
    to_s.to_f
  end

  def add(pushing)
    "#{self}#{pushing}".to_sym
  end

  def add_to_start(pushing)
    "#{pushing}#{self}".to_sym
  end

  def gsub(replace_what, with_what)
    to_s.gsub("#{replace_what}", "#{with_what}").to_sym
  end

  def remove(*whats)
    to_s.remove(*whats).to_sym
  end

  def get_left(splitter = "_")
    string = to_s.get_before_first(splitter)
    string.empty? ? self : string.to_sym
  end

  def get_mid(splitter = "_")
    string = to_s.get_mid(splitter)
    string.empty? ? self : string.to_sym
  end

  def get_right(splitter = "_")
    string = to_s.get_after_last(splitter)
    string.empty? ? self : string.to_sym
  end
end