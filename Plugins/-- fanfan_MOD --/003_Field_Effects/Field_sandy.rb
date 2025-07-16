class PokeBattle_Battle::Field_sandy < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :Sandy
    @name               = _INTL("Sandy Field")
    @duration           = duration
    @fieldback          = "Sandy"
    @field_announcement = [_INTL("The field was covered by a layer of quicksand!"),
                           _INTL(""),
                           _INTL("The quicksand disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :GROUND && user.on_ground?(aiCheck)
      },
    }

    @effects[:calc_speed] = proc { |battler, stepSpeed, mult, aiCheck|
      mult *= 1.33 if battler.shouldAbilityApply?(:SANDRUSH, aiCheck)
      next mult
    }

    @effects[:accuracy_modify] = proc { |user, target, move, modifiers, type, aiCheck|
      modifiers[:evasion_multiplier] *= 0.67 if !target.shouldTypeApply?(:GROUND, aiCheck) && !target.shouldTypeApply?(:ROCK, aiCheck) && target.on_ground?(aiCheck)
    }

  end
end

# 地面上的精灵的地面系技能威力增加30%
# 地面上的非地面系和非岩石系精灵的回避率减少33%
# 拨沙的精灵速度增加33%