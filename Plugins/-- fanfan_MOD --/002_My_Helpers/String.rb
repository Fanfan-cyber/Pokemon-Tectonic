class String
  alias_method :has?, :include?
  alias_method :push, :<<
  alias_method :add,  :<<

  def number?
    match?(/\A[+-]?(\d+_*\d)*\.*\d+([eE][+-]?\d+)?\z/)
  end

  def start_with_number?
    match?(/^\d/)
  end

  def add_to_start(pushing)
    "#{pushing}#{self}"
  end

  def remove(*whats)
    whats.flatten!
    whats.each do |what|
      gsub!("#{what}", "")
    end
    self
  end

  def remove_puncts
    accepted = "qwertyuiopasdfghjklzxcvbnm" + "QWERTYUIOPASDFGHJKLZXCVBNM" + "1234567890" + " _"
    ret = ""
    each_char do |c|
      ret += c if accepted.include?(c)
      ret += "e" if c == "é"
    end
    ret
  end

  def unblanked
    gsub(" ", "")
  end

  def to_a
    [self]
  end

  def get_before_first(splitter)
    return "" if start_with?(splitter) || !include?(splitter)
    split(splitter).first
  end

  def get_before_last(splitter)
    return "" if end_with?(splitter) || !include?(splitter)
    split(splitter)[0..-2].join(splitter)
  end

  def get_after_first(splitter)
    return "" if end_with?(splitter) || !include?(splitter)
    split(splitter)[1..-1].join(splitter)
  end

  def get_mid(splitter)
    return "" if start_with?(splitter) || end_with?(splitter) || !include?(splitter)
    split(splitter)[1..-2].join(splitter)
  end

  def get_after_last(splitter)
    return "" if end_with?(splitter) || !include?(splitter)
    split(splitter).last
  end

  def palindrome?
    trimmed = gsub(/\W+/, "").downcase
    trimmed == trimmed.reverse
  end
end