class PokeBattle_Battle::Field_misty < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                  = :Misty
    @name                = _INTL("Misty Field")
    @duration            = duration
    @fieldback           = "Misty"
    @nature_power_change = :MOONBLAST
    @secret_power_effect = 3 # tryLowerStat SPECIAL_ATTACK
    @field_announcement  = [_INTL("Mist settles on the field!"),
                            _INTL("Mist is swirling about the field!"),
                            _INTL("The mist disappeared from the field!")]

    @multipliers = {
      [:final_damage_multiplier, 0.5] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :DRAGON && target.on_ground?(aiCheck)
      },
    }

    @effects[:status_immunity] = proc { |battler, newStatus, yawn, user, showMessages, selfInflicted, move, ignoreStatus|
      if battler.on_ground?
        @battle.pbDisplay(_INTL("{1} is protected by the misty field!", battler.pbThis)) if showMessages
        next true
      end
    }

  end
end

# 自然之力变为月亮之力
# 秘密之力的附加效果变为使目标特攻减少2阶
# 地面上的精灵受到的龙系技能伤害减少50%
# 地面上的精灵不会陷入异常
# 地面上的精灵不会陷入瞌睡