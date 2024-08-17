BattleHandlers::MoveSpeedModifierAbility.add(:MAESTRO,
    proc { |ability, battler, move, battle, mult, aiCheck|
        next unless (aiCheck && move.nil?) || move.soundMove?
        if aiCheck
			next mult * (battler.moves.any? { |move| move.soundMove? } ? 2.0 : 1.0)
        else
            battler.applyEffect(:MoveSpeedDoubled,ability)
        end
    }
)

BattleHandlers::MoveSpeedModifierAbility.add(:GALEWINGS,
    proc { |ability, battler, move, battle, mult, aiCheck|
        next unless (aiCheck && move.nil?) || move.type == :FLYING
        if aiCheck
			next mult * (battler.moves.any? { |move| move.type == :FLYING } ? 2.0 : 1.0)
        else
            battler.applyEffect(:MoveSpeedDoubled,ability)
        end
    }
)

BattleHandlers::MoveSpeedModifierAbility.add(:TRENCHCARVER,
    proc { |ability, battler, move, battle, mult, aiCheck|
        next unless (aiCheck && move.nil?) || move.recoilMove?
        if aiCheck
			next mult * (battler.moves.any? { |move| move.recoilMove? } ? 2.0 : 1.0)
        else
            battler.applyEffect(:MoveSpeedDoubled,ability)
        end
    }
)

BattleHandlers::MoveSpeedModifierAbility.add(:SWIFTSTOMPS,
    proc { |ability, battler, move, battle, mult, aiCheck|
        next unless (aiCheck && move.nil?) || move.kickingMove?
        if aiCheck
			next mult * (battler.moves.any? { |move| move.kickingMove? } ? 2.0 : 1.0)
        else
            battler.applyEffect(:MoveSpeedDoubled,ability)
        end
    }
)

# Create the 2nd half of every ability above
# Actually incorporate the doubled speed in the speed calculations
BattleHandlers::MoveSpeedModifierAbility.eachKey do |abilityID|
    BattleHandlers::SpeedCalcAbility.add(abilityID,
        proc { |ability, battler, mult|
            next unless battler.effectActive?(:MoveSpeedDoubled)
            next mult * 2 if battler.effects[:MoveSpeedDoubled] == ability
        }
    )
end