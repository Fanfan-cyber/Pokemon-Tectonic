PokeBattle_Battle::BattleStartApplyCurse.add(:CURSE_ICE_SCULPTURES,
    proc { |curse_policy, battle, curses_array|
        battle.amuletActivates(
            _INTL("Move, call, step, stop.\nRend, rive, dare, halt.\nClaw, cull, dive, hold.\nFend, flee, fail, fall."),
            _INTL("Your Pokémon cannot use moves on every 4th turn.")
        )
        curses_array.push(curse_policy)
        next curses_array
    }
)

PokeBattle_Battle::BeginningOfTurnCurseEffect.add(:CURSE_ICE_SCULPTURES,
    proc { |curse_policy, battle|
        if battle.turnCount % 4 == 0
            battle.eachSameSideBattler do |b|
                b.applyEffect(:IceSculpture)
            end
        elsif battle.turnCount % 4 == 3
            battle.pbDisplay(_INTL("The freeze will arrive next turn."))
        end
    }
)