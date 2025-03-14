class PokeBattle_Battle

end

class PokeBattle_Battler

end

class AbilitySystem
  attr_reader :score
  attr_reader :flags
  attr_reader :ability_handler

  @@ability_cache = {}

  def initialize
    @score           = 0
    @flags           = []
    @ability_handler = {}
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

  def self.apply_effect(handler, *args) # args[0] must be an ability id
    get_ability(args[0])&.ability_handler&.[](handler)&.call(*args)
  end

  def self.clear_cache # didn't apply this
    @@ability_cache.clear
  end
end

class Ability_NONE < AbilitySystem

end

class Ability_EXAMPLE < AbilitySystem
  def initialize
    super
    @multiplier       = :base_damage_multiplier
    @multiplier_value = 1.3
    @activate_DamageCalcUserAbility = false

    @ability_handler[:DamageCalcUserAbility] = 
      proc { |ability, user, _target, move, mults, _baseDmg, _type, aiCheck, backfire|
        if @activate_DamageCalcUserAbility || backfire
          mults[@multiplier] *= @multiplier_value
          user.aiLearnsAbility(ability) unless aiCheck
        end
      }
  end
end

class Ability_SWIFTSTOMPS < AbilitySystem
  def initialize
    super
    @hit_cycle = 3

    @ability_handler[:GuaranteedCriticalUserAbility] = 
      proc { |_ability, move, user, _target, _battle, aiCheck|
        hits = user.battle_tracker_get(:hits_in_progress_kicking)
        hits += 1 if aiCheck
        next true if move.kickingMove? && hits % @hit_cycle == 0
      }
  end
end