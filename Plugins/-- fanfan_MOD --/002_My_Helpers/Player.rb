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

  # 获取玩家已经使用的礼物码
  def gift_code
    @gift_code ||= { :pkmn => [], :item => [] }
  end

  # 获取玩家储存在Dimension D中的精灵
  def dimension_d
    @dimension_d ||= []
  end

  # 获取玩家的储存在Team Switcher中的队伍
  def team_switcher
    @team_switcher ||= []
  end

  # 获取玩家的储存在Ability Recorder中的特性
  def ability_recorder
    @ability_recorder ||= []
  end
end