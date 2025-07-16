class PokeBattle_Battle::Field_burning < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :Burning
    @name               = _INTL("Burning Field")
    @duration           = duration
    @fieldback          = "Burning"
    @field_announcement = [_INTL("The field was covered by intense flames!"),
                           _INTL(""),
                           _INTL("The flames disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :FIRE && user.on_ground?(aiCheck)
      },
    }

    @effects[:status_immunity] = proc { |battler, newStatus, yawn, user, showMessages, selfInflicted, move, ignoreStatus|
      if (newStatus == :SLEEP || yawn) && !battler.pbHasType?(:FIRE) && battler.on_ground?
        @battle.pbDisplay(_INTL("{1} can't sleep on the burning field!", battler.pbThis)) if showMessages
        next true
      end
    }

    @effects[:EOR_field_battler] = proc { |battler|
      battler.applyFractionalDamage(1 / 16.0) if !battler.pbHasType?(:FIRE) && battler.on_ground?
    }

  end
end

# 地面上的精灵的火系技能威力增加30%
# 地面上的非火系精灵不会陷入睡眠
# 地面上的非火系精灵不会陷入瞌睡
# 地面上的非火系精灵在回合结束时损失1/16HP