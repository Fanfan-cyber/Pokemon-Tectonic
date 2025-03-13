class PokeBattle_Battle::Field_electric < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                  = :Electric
    @name                = _INTL("Electric Field")
    @duration            = duration
    @fieldback           = "Electric"
    @nature_power_change = :THUNDERBOLT
    @secret_power_effect = 1 # applyNumb
    @field_announcement  = [_INTL("The field is hyper-charged!"),
                            _INTL("An electric current is running across the field!"),
                            _INTL("The electric current disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :ELECTRIC && user.on_ground?(aiCheck)
      },
    }

    @effects[:status_immunity] = proc { |battler, newStatus, yawn, user, showMessages, selfInflicted, move, ignoreStatus|
      if (newStatus == :SLEEP || yawn) && battler.on_ground?
        @battle.pbDisplay(_INTL("{1} can't sleep on the electrified field!", battler.pbThis)) if showMessages
        next true
      end
    }

  end
end

# 自然之力变为十万伏特
# 秘密之力的附加效果变为使目标麻痹
# 地面上的精灵的电系技能威力增加30%
# 地面上的精灵不会陷入睡眠
# 地面上的精灵不会陷入瞌睡