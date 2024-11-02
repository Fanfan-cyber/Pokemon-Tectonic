class PokeBattle_Battle::Field_frozen < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :Frozen
    @name               = _INTL("Frozen Field")
    @duration           = duration
    @fieldback          = "Frozen"
    @field_announcement = [_INTL("The field was covered by a layer of sliding ice!"),
                           _INTL(""),
                           _INTL("The ice disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :ICE && user.on_ground?(aiCheck)
      },
    }

    @effects[:calc_speed] = proc { |battler, stepSpeed, mult, aiCheck|
      mult *= 1.33 if battler.shouldAbilityApply?(:SLUSHRUSH, aiCheck)
      next mult
    }

    @effects[:block_move] = proc { |move, user, target, typeMod, show_message, priority, aiCheck|
      if user.on_ground?(aiCheck) && !user.shouldTypeApply?(:ICE, aiCheck) && move.damagingMove? && !user.shouldAbilityApply?(:SLUSHRUSH, aiCheck)
        if @battle.pbRandom(100) < 33
          @battle.pbDisplay(_INTL("{1} slipped!", user.pbThis)) if show_message
          user.pbConfusionDamage(_INTL("It hurt itself!"), false, false, selfHitBasePower(user.level)) if !aiCheck
          next true
        end
      end
    }

  end
end

# 地面上的精灵的冰系技能威力增加30%
# 地面上的非冰系精灵使用伤害技能时有33%的概率滑倒，滑倒会使技能使用失败，并对自身造成基于自身等级威力的伤害
# 拨雪的精灵速度增加33%
# 拨雪的精灵速度不会滑倒