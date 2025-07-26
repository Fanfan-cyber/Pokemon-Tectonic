PokeBattle_Battle::BattleStartApplyCurse.add(:CURSE_WILD_TOTEM,
    proc { |curse_policy, battle, curses_array|
        battle.amuletActivates(
            _INTL("TODO"),
            _INTL("Enemy Pokémon experience the constant effects of Wild Totem."),
        )
        curses_array.push(curse_policy)
        next curses_array
    }
)

PokeBattle_Battle::BattlerEnterCurseEffect.add(:CURSE_WILD_TOTEM,
    proc { |_curse_policy, battler, _battle|
        next unless battler.opposes?
        battler.pbOwnSide.applyEffect(:PrimalForest, 1000)
    }
)