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

    @ability_handler[:DamageCalcUserAbility] = 
      proc { |ability, user, _target, move, mults, _baseDmg, _type, aiCheck, backfire|
        unless backfire
          mults[@multiplier] *= @multiplier_value
          user.aiLearnsAbility(ability) unless aiCheck
        end
      }
  end
end