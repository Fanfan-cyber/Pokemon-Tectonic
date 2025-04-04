
BattleHandlers::CriticalCalcUserAllyAbility.add(:SPECTRUMVISION,
    proc { |ability, user, _target, _move, c|
        next c + 1
    }
)

BattleHandlers::CriticalCalcUserAllyAbility.add(:VICTORYSTAR,
    proc { |ability, user, _target, _move, c|
        next c + 1
    }
)
