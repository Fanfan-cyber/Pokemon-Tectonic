class PokeBattle_BattleTracker
  def initialize
    @battled_battlers = [] # used for Switch Healing
    @turn_switched    = {} # used to record the turnCount when a Pokemon switches out
    @revenge          = {} # used for Revenge Mechanics
  end
end

class PokeBattle_BattlerBattleTracker
  def initialize
    @faint_healing_triggered  = false # used to record whether Faint Healing triggered or not
    @steps_before_switching   = {}    # used to record Stat Steps
    @hits_in_progress         = 0     # used to record the count of hits in progress
    @hits_in_progress_kicking = 0     # used to record the count of kicking hits in progress
    @warned                   = []    # used for Cursed Tail

    @being_hits = 0
    @hits_dealt = 0
    @hits_taken = 0

    @crits_dealt = 0
    @crits_taken = 0

    @status_inflict = 0
    @status_be_inflicted = 0

    @stat_stages_up = 0
    @stat_stages_down = 0

    @abilities_triggered = 0
  end
end

class PokeBattle_BattlerTracker
  def initialize
    @forced_engagement = nil # used for Forced Engagement
  end
end

class PokeBattle_Battle
  attr_reader :battle_tracker
  attr_reader :battler_battle_tracker

  def tracker_get(tracker)
    @battle_tracker.instance_variable_get("@#{tracker}")
  end

  def tracker_set(tracker, value)
    @battle_tracker.instance_variable_set("@#{tracker}", value)
  end

  def tracker_increment(tracker, value = 1)
    tracker_set(tracker, tracker_get(tracker) + value)
  end

  def tracker_multiply(tracker, multiplier = 1)
    tracker_set(tracker, tracker_get(tracker) * multiplier)
  end

  def tracker_clear(tracker)
    case tracker
    when Numeric
      tracker_set(tracker, 0)
    when TrueClass
      tracker_set(tracker, false)
    when Array
      tracker_set(tracker, [])
    when Hash
      tracker_set(tracker, {})
    else
      tracker_set(tracker, nil)
    end
  end

  def tracker_avatars_purge; end
end

class PokeBattle_Battler
  def battler_battle_tracker_get
    unless @battle.battler_battle_tracker[@index & 1][@pokemonIndex]
      @battle.battler_battle_tracker[@index & 1][@pokemonIndex] = PokeBattle_BattlerBattleTracker.new
    end
    @battle.battler_battle_tracker[@index & 1][@pokemonIndex]
  end

  def battle_tracker_get(tracker)
    battler_battle_tracker_get.instance_variable_get("@#{tracker}")
  end

  def battle_tracker_set(tracker, value)
    battler_battle_tracker_get.instance_variable_set("@#{tracker}", value)
  end

  def battle_tracker_increment(tracker, value = 1)
    battle_tracker_set(tracker, battle_tracker_get(tracker) + value)
  end

  def battle_tracker_multiply(tracker, multiplier = 1)
    battle_tracker_set(tracker, battle_tracker_get(tracker) * multiplier)
  end

  def battle_tracker_clear(tracker)
    case tracker
    when Numeric
      battle_tracker_set(tracker, 0)
    when TrueClass
      battle_tracker_set(tracker, false)
    when Array
      battle_tracker_set(tracker, [])
    when Hash
      battle_tracker_set(tracker, {})
    else
      battle_tracker_set(tracker, nil)
    end
  end

  def battle_tracker_avatars_purge
    battle_tracker_set(:warned, [])
  end
end

class PokeBattle_Battler
  attr_reader :battler_tracker

  def tracker_get(tracker)
    @battler_tracker.instance_variable_get("@#{tracker}")
  end

  def tracker_set(tracker, value)
    @battler_tracker.instance_variable_set("@#{tracker}", value)
  end

  def tracker_increment(tracker, value = 1)
    tracker_set(tracker, tracker_get(tracker) + value)
  end

  def tracker_multiply(tracker, multiplier = 1)
    tracker_set(tracker, tracker_get(tracker) * multiplier)
  end

  def tracker_clear(tracker)
    case tracker
    when Numeric
      tracker_set(tracker, 0)
    when TrueClass
      tracker_set(tracker, false)
    when Array
      tracker_set(tracker, [])
    when Hash
      tracker_set(tracker, {})
    else
      tracker_set(tracker, nil)
    end
  end

  def tracker_avatars_purge; end
end