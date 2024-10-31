PokeBattle_Battle::BattleStartApplyCurse.add(:CURSE_DOUBLE_ABILITIES,
    proc { |curse_policy, battle, curses_array|
        battle.amuletActivates(
            _INTL("Ought Not the Foxtrot to Double Aught of What We Sought?"),
            _INTL("Enemy Pokémon have all of their legal abilities!")
        )
        curses_array.push(curse_policy)
        next curses_array
    }
)