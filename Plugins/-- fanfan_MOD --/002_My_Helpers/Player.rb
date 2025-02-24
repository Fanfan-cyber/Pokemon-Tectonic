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

  def set_max_money
    @money = Settings::MAX_MONEY
  end

  def gift_code
    @gift_code ||= { :pkmn => [], :item => [] }
  end

  def dimension_d
    @dimension_d ||= []
  end

  def team_switcher
    @team_switcher ||= []
  end

  def ability_recorder
    @ability_recorder ||= []
  end
end