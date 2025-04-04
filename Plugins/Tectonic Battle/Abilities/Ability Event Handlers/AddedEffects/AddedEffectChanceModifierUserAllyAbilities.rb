BattleHandlers::AddedEffectChanceModifierUserAllyAbility.add(:VICTORYSTAR,
    proc { |ability, user, target, move, chance|
        chance *= 2.0
        next chance
    }
)