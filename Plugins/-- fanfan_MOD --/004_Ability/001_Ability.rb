class PokeBattle_Battle

end

class PokeBattle_Battler

end

class AbilitySystem
  attr_reader :score, :flags, :off_mult, :def_mult, :ability_handler

  @@ability_cache = {}

  def initialize
    @score           = 0
    @flags           = []
    @off_mult        = {}
    @def_mult        = {}
    @ability_handler = {}
  end

  def self.clear_cache # didn't apply this
    @@ability_cache.clear
  end

  def self.get_ability(ability_id)
    class_name = "Ability_#{ability_id}"
    return unless Object.const_defined?(class_name)
    @@ability_cache[ability_id] ||= Object.const_get(class_name).new
  end

  def self.get_score(ability_id)
    get_ability(ability_id)&.score || 0
  end

  def self.get_flags(ability_id)
    get_ability(ability_id)&.flags || []
  end

  def self.apply_effect(handler, ability_id, *args)
    get_ability(ability_id)&.ability_handler&.[](handler)&.call(handler, ability_id, *args)
  end

  def self.apply_effect_backfire(handler, ability_id, mults)
    off_mult = get_ability(ability_id)&.off_mult
    return unless off_mult
    mult = off_mult[handler]
    return if !mult || mult.empty?
    mults[mult[0]] *= mult[1]
  end
end

class Ability_NONE < AbilitySystem

end

class Ability_EXAMPLE < AbilitySystem
  def initialize
    super
    @off_mult = { :DamageCalcUserAbility => [:base_damage_multiplier, 1.3] }

    @ability_handler[:DamageCalcUserAbility] = 
      proc { |_handler, _ability, _user, _target, _move, _mults, _baseDmg, _type, _aiCheck, _backfire|

      }
  end
end

class Ability_SWIFTSTOMPS < AbilitySystem
  def initialize
    super
    @hit_cycle = 3

    @ability_handler[:GuaranteedCriticalUserAbility] = 
      proc { |_handler, _ability, move, user, _target, _battle, aiCheck|
        hits = user.battle_tracker_get(:hits_in_progress_kicking)
        hits += 1 if aiCheck
        next true if move.kickingMove? && hits % @hit_cycle == 0
      }
  end
end