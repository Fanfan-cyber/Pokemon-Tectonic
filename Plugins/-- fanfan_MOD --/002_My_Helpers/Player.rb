class Player
  attr_reader :ta

  def check_ta
    @ta ||= TA::TA_Vars.new
  end

  def get_ta(var, default = nil)
    check_ta.get(var, default)
  end

  def set_ta(var, value)
    check_ta.set(var, value)
  end

  def increase_ta(var, increment = 1)
    check_ta.increase(var, increment)
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