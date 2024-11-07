class PokeBattle_Battle::Field_ravine < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :Ravine
    @name               = _INTL("Ravine")
    @duration           = duration
    @fieldback          = "Ravine"
    @tailwind_duration  = 2
    @field_announcement = [_INTL("The field was become an ravine!"),
                           _INTL(""),
                           _INTL("The cliff disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :FLYING && !user.on_ground?(aiCheck)
      },
      [:final_damage_multiplier, 0.75] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if target.shouldTypeApply?(:FLYING, aiCheck) && !target.on_ground?(aiCheck) && Effectiveness.super_effective?(typeModToCheck(@battle, type, user, target, move, aiCheck))
      },
    }

  end
end

# 不在地面上的精灵的飞行系技能威力增加30%
# 不在地面上的飞行系精灵受到的效果拔群的技能伤害减少25%
# 顺风的持续时间增加2个回合