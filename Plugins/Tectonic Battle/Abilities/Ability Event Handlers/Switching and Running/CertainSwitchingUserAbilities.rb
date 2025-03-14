BattleHandlers::CertainSwitchingUserAbility.add(:SLICKSURFACE,
    proc { |ability, switcher, battle, trappingProc|
        if trappingProc
            battle.pbShowAbilitySplash(switcher, ability)
            battle.pbDisplay(_INTL("{1} can switch out regardless!", switcher.pbThis))
            battle.pbHideAbilitySplash(switcher)
        end
        next true
    }
)

BattleHandlers::CertainSwitchingUserAbility.add(:RUNNINGFREE,
    proc { |ability, switcher, battle, trappingProc|
        if trappingProc
            battle.pbShowAbilitySplash(switcher, ability)
            battle.pbDisplay(_INTL("{1} can switch out regardless!", switcher.pbThis))
            battle.pbHideAbilitySplash(switcher)
        end
        next true
    }
)