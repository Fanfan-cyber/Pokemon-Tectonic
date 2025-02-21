class PokeBattle_BattleCount
  def initialize
    @faint_healing_triggered = false
    @warned                  = false # used for Cursed Tail

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
  def battler_battle_count_get
    unless @battle.battle_count[@index & 1][@pokemonIndex]
      @battle.battle_count[@index & 1][@pokemonIndex] = PokeBattle_BattleCount.new
    end
    @battle.battle_count[@index & 1][@pokemonIndex]
  end

  def battle_count_get(type)
    battler_battle_count_get.instance_variable_get("@#{type}")
  end

  def battle_count_set(type, value)
    battler_battle_count_get.instance_variable_set("@#{type}", value)
  end

  def battle_count_increment(type, value = 1)
    battle_count_set(type, battle_count_get(type) + value)
  end

  def battle_count_multiply(type, multiplier = 1)
    battle_count_set(type, battle_count_get(type) * multiplier)
  end

  def battle_count_clear(type)
    case type
    when Numeric
      battle_count_set(type, 0)
    when TrueClass
      battle_count_set(type, false)
    when Array
      battle_count_set(type, [])
    when Hash
      battle_count_set(type, {})
    else
      battle_count_set(type, nil)
    end
  end

  def battle_count_avatars_purge
    battle_count_set(:warned, false)
  end
end