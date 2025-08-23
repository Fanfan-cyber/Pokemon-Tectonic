BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:EMERGENCYEXIT,
    proc { |ability, battler, battle|
        next false if battler.fainted?
        next false if battle.pbAllFainted?(battler.idxOpposingSide)
        next battle.triggeredSwitchOut(battler.index, ability: ability)
    }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.copy(:EMERGENCYEXIT, :WIMPOUT)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:ANCESTRALSUMMONS,
    proc { |ability, battler, battle|
        next false if battler.fainted?
        next false if battle.pbAllFainted?(battler.idxOpposingSide)
        next battle.triggeredSwitchOut(battler.index, ability: ability, effect: true)
    }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:BERSERK,
  proc { |ability, battler, _battle|
      battler.pbRaiseMultipleStatSteps(ATTACKING_STATS_2, battler, ability: ability)
      next false
  }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:ADRENALINERUSH,
  proc { |ability, battler, _battle|
      battler.tryRaiseStat(:SPEED, battler, increment: 4, ability: ability)
      next false
  }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:BOULDERNEST,
  proc { |ability, battler, battle|
      battle.pbShowAbilitySplash(battler, ability)
      if battler.pbOpposingSide.effectActive?(:StealthRock)
          battle.pbDisplay(_INTL("But there were already pointed stones floating around {1}!",
                battler.pbOpposingTeam(true)))
      else
          battler.pbOpposingSide.applyEffect(:StealthRock)
      end
      battle.pbHideAbilitySplash(battler)
      next false
  }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:REAWAKENEDPOWER,
  proc { |ability, battler, _battle|
      battler.pbMaximizeStatStep(:SPECIAL_ATTACK, battler, self, ability: ability)
      next false
  }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:PRIMEVALDISGUISE,
    proc { |ability, battler, battle|
        next unless battler.illusion?
        battle.pbShowAbilitySplash(battler,ability)
        battler.disableEffect(:Illusion)
        battle.scene.pbChangePokemon(battler, battler.pokemon)
        battle.pbSetSeen(battler)
        battle.pbHideAbilitySplash(battler)
        next false
    }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:BATTLEHARDENED,
  proc { |ability, battler, _battle|
      battler.pbRaiseMultipleStatSteps([:DEFENSE, 3, :SPECIAL_DEFENSE, 3], battler, ability: ability)
      next false
  }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:WIRECUTTER,
  proc { |ability, battler, battle|
      battle.pbShowAbilitySplash(battler, ability)
      if battler.pbOpposingSide.effectActive?(:LiveWire)
          battle.pbDisplay(_INTL("But a live wire already sits near {1}!",
                battler.pbOpposingTeam(true)))
      else
          battler.pbOpposingSide.applyEffect(:LiveWire)
      end
      battle.pbHideAbilitySplash(battler)
      next false
  }
)

BattleHandlers::AbilityOnHPDroppedBelowHalf.add(:CASHFLOW,
  proc { |ability, battler, battle|
      next if battler.fainted?
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
      next false
  }
)