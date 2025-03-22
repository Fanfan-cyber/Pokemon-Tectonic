class AbilitySystem
  attr_reader :id, :score, :flags, :ability_handler

  @@ability_cache = {}

  def initialize(id)
    @id              = id
    @score           = 0
    @flags           = []
    @ability_handler = {}
  end

  def self.clear_cache # didn't apply this
    @@ability_cache.clear
  end

  def self.get_ability(id)
    class_name = "Ability_#{id}"
    return unless Object.const_defined?(class_name)
    @@ability_cache[id] ||= Object.const_get(class_name).new(id)
  end

  def self.get(id, attr)
    ability = get_ability(id)
    return unless ability
    ability.instance_variable_get("@#{attr}")
  end

  def self.get_score(id)
    get_ability(id)&.score || 0
  end

  def self.get_flags(id)
    get_ability(id)&.flags || []
  end

  def self.apply_effect(handler, id, *args)
    get_ability(id)&.ability_handler&.[](handler)&.call(handler, id, *args)
  end

  def self.apply_effect_backfire(handler, id, mults)
    ability = get_ability(id)
    return unless ability
    ability_class = ability.class
    return unless ability_class.const_defined?(:OFF_MULT)
    off_mult = ability_class.const_get(:OFF_MULT)
    handler_mult = off_mult[handler]
    return if !handler_mult || handler_mult.empty?
    handler_mult.each { |mult, value| mults[mult] *= value }
  end
end

class Ability_EXAMPLE < AbilitySystem
  OFF_MULT = { :DamageCalcUserAbility => { :base_damage_multiplier => 1.3 } }

  DamageCalcUserAbility =
    proc { |_handler, _ability, _user, _target, _move, _mults, _baseDmg, _type, _aiCheck, _backfire|
      OFF_MULT[_handler].each { |mult, value| _mults[mult] *= value }
    }

  def initialize(id)
    super
    @ability_handler[:DamageCalcUserAbility] = DamageCalcUserAbility
  end
end

class Ability_SWIFTSTOMPS < AbilitySystem
  HIT_CYCLE = 3

  GuaranteedCriticalUserAbility =
    proc { |_handler, _ability, move, user, _target, _battle, aiCheck|
      hits = user.battle_tracker_get(:hits_in_progress_kicking)
      hits += 1 if aiCheck
      next true if move.kickingMove? && hits % HIT_CYCLE == 0
    }

  def initialize(id)
    super
    @ability_handler[:GuaranteedCriticalUserAbility] = GuaranteedCriticalUserAbility
  end
end