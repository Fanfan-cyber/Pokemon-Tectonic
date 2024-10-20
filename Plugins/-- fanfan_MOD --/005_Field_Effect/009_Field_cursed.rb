class PokeBattle_Battle::Field_cursed < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :Cursed
    @name               = _INTL("Cursed Field")
    @duration           = duration
    @fieldback          = "Cursed"
    @field_announcement = [_INTL("The field was cursed by evil spirits!"),
                           _INTL(""),
                           _INTL("The spirits disappeared from the field!")]

    @multipliers = {
      [:base_damage_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults, aiCheck|
        next true if type == :GHOST && user.on_ground?(aiCheck)
      },
    }

    @effects[:no_charging] = proc { |user, move|
      next true if %i[PHANTOMFORCE SHADOWFORCE].include?(move.id) && user.on_ground?
    }

    @effects[:block_heal] = proc { |battler, overheal|
      next true if !battler.pbHasType?(:GHOST) && !battler.pbHasType?(:DARK)
    }

  end
end

# 地面上的精灵的鬼系技能威力增加30%
# 非鬼系和非恶系精灵无法回复HP
# 地面上的精灵使用的潜灵奇袭无需蓄力
# 地面上的精灵使用的暗影潜袭无需蓄力