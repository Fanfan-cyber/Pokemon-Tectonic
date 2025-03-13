class PokeBattle_Battle::Field_venomous < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :Venomous
    @name               = _INTL("Venomous Field")
    @duration           = duration
    @fieldback          = "Venomous"
    @field_announcement = [_INTL("The field was covered by a venomous sludge!"),
                           _INTL(""),
                           _INTL("The sludge disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if user.on_ground?(aiCheck) && type == :POISON
      },
    }

    @effects[:EOR_field_battler] = proc { |battler|
      battler.applyPoison if !battler.pbHasType?(:POISON) && battler.on_ground? && battler.canPoison?(nil, false)
    }

    @effects[:block_berry] = proc { |battler|
      next true if !battler.pbHasType?(:POISON) && battler.on_ground?
    }

  end
end

# 地面上的精灵的毒系技能威力增加30%
# 地面上的非毒系精灵无法食用树果
# 地面上的非毒系精灵在回合结束时会陷入中毒