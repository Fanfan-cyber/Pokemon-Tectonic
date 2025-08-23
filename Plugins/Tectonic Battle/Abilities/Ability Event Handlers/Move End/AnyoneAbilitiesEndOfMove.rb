BattleHandlers::AnyoneAbilityEndOfMove.add(:CELEBRATION,
    proc { |ability, battler, user, targets, move, battle|
        next unless move.danceMove?
        battler.applyFractionalHealing(1.0 / 5.0, ability: ability, canOverheal: true)
    }
)

BattleHandlers::AnyoneAbilityEndOfMove.add(:CHOREOGRAPHY,
    proc { |ability, battler, user, targets, move, battle|
        next unless move.danceMove?
        battler.pbRaiseMultipleStatSteps([:SPEED, 1], user, ability: ability)
    }
)

BattleHandlers::AnyoneAbilityEndOfMove.add(:GROOVY,
    proc { |ability, battler, user, targets, move, battle|
        next unless move.danceMove?
        battler.pbRaiseMultipleStatSteps(ATTACKING_STATS_1, user, ability: ability)
    }
)

BattleHandlers::AnyoneAbilityEndOfMove.add(:CASHFLOW,
    proc { |ability, battler, user, targets, move, battle|
      next if battler.fainted? || battler.hp >= battler.totalhp / 2
      next unless battler.pbOwnSide.effectActive?(:PayDay)
      next unless battler.canHeal?(true)
      maxCoinsCanHealFrom = battler.maxOverhealingPossible * CASHOUT_HEALING_DIVISOR
      coinsToConsume = [battler.pbOwnSide.countEffect(:PayDay), maxCoinsCanHealFrom].min
      healingAmt = coinsToConsume / CASHOUT_HEALING_DIVISOR
      battle.pbShowAbilitySplash(battler, ability)
      healingMessage = _INTL("{1} gobbles up the scattered coins!", battler.pbThis)
      battler.pbRecoverHP(healingAmt, true, true, true, healingMessage, canOverheal: true)
      battler.pbOwnSide.effects[:PayDay] -= coinsToConsume
      battle.pbHideAbilitySplash(battler)
    }
)