BattleHandlers::MoveBlockingAbility.add(:ROYALMAJESTY,
  proc { |ability, bearer, user, targets, move, battle, aiCheck|
        priority = battle.getMovePriority(move, user, targets, aiCheck)
        next false unless priority && priority > 0
        next false unless bearer.opposes?(user)
        next true
  }
)

BattleHandlers::MoveBlockingAbility.add(:KILLJOY,
    proc { |ability, _bearer, _user, _targets, move, _battle, aiCheck|
        next move.danceMove? || move.soundMove?
    }
)

BattleHandlers::MoveBlockingAbility.add(:DESICCATE,
    proc { |ability, _bearer, _user, _targets, move, battle, aiCheck|
        next %i[GRASS WATER].include?(move.calcType) && battle.sandy?
    }
)

BattleHandlers::MoveBlockingAbility.add(:DECONTAMINATION,
    proc { |ability, _bearer, _user, _targets, move, battle, aiCheck|
        next %i[BUG POISON].include?(move.calcType) && battle.moonGlowing?
    }
)