class Player
  attr_reader :ta

  # 获取TA的某个变量值
  def get_ta(var)
    @ta&.get(var)
  end

  # 设置TA的某个变量的值
  def set_ta(var, value)
    @ta ||= TA::TA_Vars.new
    @ta.set(var, value)
  end

  def is_player
    @is_player ||= true
  end

  # 设置最大金钱
  def set_max_money
    @money = Settings::MAX_MONEY
  end
end