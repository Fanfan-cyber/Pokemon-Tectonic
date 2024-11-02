BattleHandlers::TypeCalcAbility.add(:HAUNTED,
    proc { |ability, battler, types|
        types.push(:GHOST)
        next types
    }
)

BattleHandlers::TypeCalcAbility.add(:INFECTED,
    proc { |ability, battler, types|
        types.push(:GRASS)
        next types
    }
)

BattleHandlers::TypeCalcAbility.add(:RUSTWRACK,
    proc { |ability, battler, types|
        types.push(:STEEL)
        next types
    }
)

BattleHandlers::TypeCalcAbility.add(:SLUGGISH,
    proc { |ability, battler, types|
        types.push(:BUG)
        next types
    }
)

BattleHandlers::TypeCalcAbility.add(:UNIDENTIFIED,
    proc { |ability, battler, types|
        types.push(:MUTANT) unless types.include?(:MUTaNT)
        next types
    }
)