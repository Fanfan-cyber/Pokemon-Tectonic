class PokeBattle_Battle::Field_grassy < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                  = :Grassy
    @name                = _INTL("Grassy Field")
    @duration            = duration
    @fieldback           = "Grassy"
    @nature_power_change = :ENERGYBALL
    @secret_power_effect = 2 # applySleep
    @field_announcement  = [_INTL("The field is in full bloom!"),
                            _INTL("Grass is covering the field!"),
                            _INTL("The grass disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :GRASS && user.on_ground?(aiCheck)
      },
      [:final_damage_multiplier, 0.5, _INTL("The grass softened the attack!")] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if %i[EARTHQUAKE BULLDOZE].include?(move.id) && target.on_ground?(aiCheck)
      },
    }

    @effects[:EOR_field_battler] = proc { |battler|
      battler.applyFractionalHealing(1 / 16.0) if battler.on_ground?
    }

  end
end

# 自然之力变为能量球
# 秘密之力的附加效果变为使目标睡眠
# 地面上的精灵的草系技能威力增加30%
# 地震对地面上的目标伤害减少50%
# 重踏对地面上的目标伤害减少50%
# 地面上的精灵在回合结束时回复1/16HP