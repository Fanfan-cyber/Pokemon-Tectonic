class PokeBattle_Battle::Field_swamp < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :Swamp
    @name               = _INTL("Swamp")
    @duration           = duration
    @fieldback          = "Swamp"
    @field_announcement = [_INTL("The field was taken by a swamp!"),
                           _INTL(""),
                           _INTL("The swamp disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if user.on_ground?(aiCheck) && type == :WATER
      },
      [:base_damage_multiplier, 0.5] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if %i[EARTHQUAKE BULLDOZE].include?(move.id)
      },
    }

    @effects[:calc_speed] = proc { |battler, stepSpeed, mult, aiCheck|
      mult *= 0.75 if !battler.shouldAbilityApply?(:SWIFTSWIM, aiCheck) && battler.on_ground?(aiCheck) && !battler.shouldTypeApply?(:WATER, aiCheck)
      mult *= 1.33 if battler.shouldAbilityApply?(:SWIFTSWIM, aiCheck)
      next mult
    }

    @effects[:EOR_field_battler] = proc { |battler|
      battler.applyFractionalHealing(WEATHER_ABILITY_HEALING_FRACTION) if battler.hasActiveAbility?(:DRYSKIN)
    }

  end
end

# 地面上的精灵的水系技能威力增加30%
# 地震的威力减少50%
# 重踏的威力减少50%
# 非轻快的地面上的非水系精灵速度减少25%
# 轻快的精灵速度增加33%
# 干燥皮肤的精灵在回合结束时回复1/8HP