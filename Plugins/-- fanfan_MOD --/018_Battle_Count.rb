class PokeBattle_BattleCount
  def initialize
    @hits_in_progress = 0 # Only done this
    @being_hits = 0
    @hits_dealt = 0
    @hits_taken = 0

    @crits_dealt = 0
    @crits_taken = 0

    @moves_in_progress = 0
    @moves_used = 0
    @status_moves_in_progress = 0
    @status_moves_used = 0
    @damage_moves_in_progress = 0
    @damage_moves_used = 0
    @physical_moves_in_progress = 0
    @physical_moves_used = 0
    @special_moves_in_progress = 0
    @special_moves_used = 0
    # each type

    @status_inflict = 0
    @status_be_inflicted = 0

    @stat_stages_up = 0
    @stat_stages_down = 0

    @abilities_triggered = 0
  end
end

class PokeBattle_Battle
  attr_reader :battle_count
end

class PokeBattle_Battler
  def get_battler_battle_count
    unless @battle.battle_count[@index & 1][@pokemonIndex]
      @battle.battle_count[@index & 1][@pokemonIndex] = PokeBattle_BattleCount.new
    end
    @battle.battle_count[@index & 1][@pokemonIndex]
  end

  def get_battle_count(type)
    get_battler_battle_count.instance_variable_get("@#{type}")
  end

  def set_battle_count(type, value)
    get_battler_battle_count.instance_variable_set("@#{type}", value)
  end

  def increment_battle_count(type, value = 1)
    set_battle_count(type, get_battle_count(type) + value)
  end

  def multiply_battle_count(type, multiplier = 1)
    set_battle_count(type, get_battle_count(type) * multiplier)
  end

  def clear_battle_count(type, value = 0)
    set_battle_count(type, value)
  end
end