class PokeBattle_Battle::Field_psychic < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                  = :Psychic
    @name                = _INTL("Psychic Field")
    @duration            = duration
    @fieldback           = "Psychic"
    @nature_power_change = :PSYCHIC
    @secret_power_effect = 4 # tryLowerStat SPEED
    @field_announcement  = [_INTL("The field became mysterious!"),
                            _INTL("The field is weird!"),
                            _INTL("The weirdness disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :PSYCHIC && user.on_ground?(aiCheck)
      },
    }

    @effects[:block_move] = proc { |move, user, target, typeMod, show_message, priority, aiCheck|
      if target.on_ground?(aiCheck) && target.opposes?(user) && priority > 0
        @battle.pbDisplay(_INTL("{1} is protected by the psychic field!", target.pbThis)) if show_message
        next true
      end
    }

  end
end

# 自然之力变为精神强念
# 秘密之力的附加效果变为使目标速度减少2阶
# 地面上的精灵的超能系技能威力增加30%
# 地面上的精灵不会受到对手先制技能的攻击或影响