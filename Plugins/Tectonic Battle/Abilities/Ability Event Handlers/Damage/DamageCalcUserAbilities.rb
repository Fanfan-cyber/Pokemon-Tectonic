BattleHandlers::DamageCalcUserAbility.add(:ARCTICARIETTE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      if aiCheck
          mults[:base_damage_multiplier] *= 1.3 if move.soundMove? || backfire
      elsif move.powerBoost || backfire
          mults[:base_damage_multiplier] *= 1.3
          user.aiLearnsAbility(ability) unless aiCheck
      end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:NORMALIZE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      if aiCheck
          mults[:base_damage_multiplier] *= 1.5 if type != :NORMAL || backfire
      elsif move.powerBoost || backfire
          mults[:base_damage_multiplier] *= 1.5
          user.aiLearnsAbility(ability) unless aiCheck
      end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:ANALYTIC,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      if aiCheck
          mults[:base_damage_multiplier] *= 1.3 if target.pbSpeed < user.pbSpeed || backfire
      elsif (target.battle.choices[target.index][0] != :UseMove &&
            target.battle.choices[target.index][0] != :Shift) ||
            target.movedThisRound? || backfire
          mults[:base_damage_multiplier] *= 1.3
          user.aiLearnsAbility(ability) unless aiCheck
      end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:DEFEATIST,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.belowHalfHealth? || backfire
      mults[:attack_multiplier] /= 2
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:PERFECTIONIST,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if !target.damageState.critical || backfire # TODO: Ai check
      mults[:final_damage_multiplier] /= 2
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:MEGALAUNCHER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.pulseMove? || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

=begin
BattleHandlers::DamageCalcUserAbility.add(:REFRACTIVE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck|
    if move.pulseMove?
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)
=end

BattleHandlers::DamageCalcUserAbility.add(:RECKLESS,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.recoilMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:LINEBACKER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.recoilMove? || backfire
      mults[:base_damage_multiplier] *= 2.0
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:HOOLIGAN,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.recoilMove? || move.soundMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:STONEMANE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.recoilMove? || backfire
      mults[:base_damage_multiplier] *= 1.2
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:STRONGJAW,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.bitingMove? || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SHEERFORCE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.randomEffect? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TECHNICIAN,
  proc { |ability, user, target, move, mults, baseDmg, type, aiCheck, backfire|
      if user.index != target.index && move && move.id != :STRUGGLE &&
            baseDmg * mults[:base_damage_multiplier] <= 60 || backfire
          mults[:base_damage_multiplier] *= 1.5
          user.aiLearnsAbility(ability) unless aiCheck
      end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:IRONFIST,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.punchingMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)
BattleHandlers::DamageCalcUserAbility.copy(:IRONFIST, :MYSTICFIST)

BattleHandlers::DamageCalcUserAbility.add(:KNUCKLEDUSTER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.punchingMove? || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)
=begin
BattleHandlers::DamageCalcUserAbility.add(:SHIFTINGFIST,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.punchingMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)
=end
BattleHandlers::DamageCalcUserAbility.add(:BRISK,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.windMove? || backfire
      mults[:attack_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:GALEFORCE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.windMove? || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:LOUD,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.soundMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.copy(:LOUD, :TUNEDOUT)

BattleHandlers::DamageCalcUserAbility.add(:EARSPLITTING,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.soundMove? || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SWORDPLAY,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.bladeMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.copy(:SWORDPLAY, :RAZORSEDGE, :BLADEBRAINED)

BattleHandlers::DamageCalcUserAbility.add(:SHARPNESS,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.bladeMove? || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:IRONHEEL,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.kickingMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.copy(:IRONHEEL, :HEAVYDUTYHOOVES)

BattleHandlers::DamageCalcUserAbility.add(:BADOMEN,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.foretoldMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:GORGING,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.healingMove? || backfire
      mults[:attack_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:EXPERTISE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if Effectiveness.super_effective?(typeModToCheck(user.battle, type, user, target, move, aiCheck)) || backfire
      mults[:final_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.copy(:EXPERTISE,:NEUROFORCE)

BattleHandlers::DamageCalcUserAbility.add(:TINTEDLENS,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if Effectiveness.resistant?(typeModToCheck(user.battle, type, user, target, move, aiCheck)) || backfire
      mults[:final_damage_multiplier] *= 2
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SNIPER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.damageState.critical || backfire # TODO: Ai check
      mults[:final_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:STAKEOUT,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.effectActive?(:SwitchedIn) || backfire
      mults[:attack_multiplier] *= 2
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:LIMINAL,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.effectActive?(:SwitchedIn) || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:AFTERIMAGE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.effectActive?(:SwitchedIn) || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:QUARRELSOME,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.firstTurn? || backfire
      mults[:attack_multiplier] *= 2.0
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:STEELWORKER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :STEEL || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.copy(:STEELWORKER, :STEELYSHELL, :PULVERIZE)

BattleHandlers::DamageCalcUserAbility.add(:STRATAGEM,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :ROCK || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SURFSUP,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :WATER || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:ERUDITE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :PSYCHIC || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:PECKINGORDER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :FLYING || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TUNNELMAKER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :GROUND || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SUBZERO,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :ICE || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:PALEOLITHIC,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :ROCK || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SUPERALLOY,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :STEEL || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SCALDINGSMOKE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :POISON || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:STEELYSPIRIT,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :STEEL || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:VERDANT,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :GRASS || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TOXICATTITUDE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :POISON || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:UNCANNYCOLD,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :ICE || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:WATERBUBBLE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :WATER || backfire
      mults[:attack_multiplier] *= 2
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SHOCKSTYLE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :FIGHTING || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:HUSTLE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
  }
)

BattleHandlers::DamageCalcUserAbility.add(:DRAGONSMAW,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :DRAGON || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TRANSISTOR,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if type == :ELECTRIC || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:MIDNIGHTSUN,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.battle.sunny? && type == :DARK || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:DARKENEDSKIES,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.battle.sandy? && type == :DARK || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:RAINPRISM,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.battle.rainy? && type == :FAIRY || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:WORLDQUAKE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.battle.eclipsed? && type == :GROUND || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TIDALFORCE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.battle.moonGlowing? && type == :WATER || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TAIGATREKKER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.battle.icy? && type == :GRASS || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:VARIETY,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.lastMoveUsed != move.id && !user.lastMoveFailed || backfire
      mults[:attack_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:PHASESHIFT,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if !user.lastMoveUsedType.nil? && type != user.lastMoveUsedType || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:ARMORPIERCING,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if  target.steps[:DEFENSE] > 0 ||
        target.steps[:SPECIAL_DEFENSE] > 0 ||
        target.protectedByScreen? || backfire
      mults[:base_damage_multiplier] *= 2.0
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TERRITORIAL,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.battle.pbWeather != :None || backfire
      mults[:attack_multiplier] *= 1.2
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SOULREAD,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      if !target.lastMoveUsedType.nil? && !target.pbTypes(true).include?(target.lastMoveUsedType) || backfire
          mults[:attack_multiplier] *= 2.0
          user.aiLearnsAbility(ability) unless aiCheck
      end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:DOUBLECHECK,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.tookDamage || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:DRAGONSLAYER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.hasType?(:DRAGON) || backfire
      mults[:base_damage_multiplier] *= 2.0
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SPACEINTERLOPER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      mults[:attack_multiplier] *= 0.5
      user.aiLearnsAbility(ability) unless aiCheck
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TIMEINTERLOPER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      mults[:attack_multiplier] *= 3.0 / 4.0
      user.aiLearnsAbility(ability) unless aiCheck
  }
)

BattleHandlers::DamageCalcUserAbility.add(:MARINEMENACE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.function == "TwoTurnAttackInvulnerableUnderwater" || backfire # Dive, # Depth Charge
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:EXCAVATOR,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.function == "TwoTurnAttackInvulnerableUnderground" || backfire # Dig, Undermine
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:STEEPFLYING,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.function == "TwoTurnAttackInvulnerableInSky" || backfire # Fly, Divebomb
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:GRIPSTRENGTH,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.function == "BindTarget3" || backfire # 3-turn DOT trapping moves
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

UNCONVENTIONAL_MOVE_CODES = %w[
    AttacksWithTargetsStats
    AttacksWithDefense
    AttacksWithSpDef
    DoesPhysicalDamage
    DoesSpecialDamage
    TargetsAttackDefends
    TargetsSpAtkDefends
].freeze

BattleHandlers::DamageCalcUserAbility.add(:UNCONVENTIONAL,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if UNCONVENTIONAL_MOVE_CODES.include?(move.function) || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:RATTLEEM,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.effectActive?(:FlinchImmunity) || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:AURORAPRISM,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if !user.pbHasType?(type) || backfire
      mults[:base_damage_multiplier] *= 1.5
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:FLEXIBLE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if !user.pbHasType?(type) || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:FIRSTSTRIKE,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      priority = user.battle.choices[user.index][4] || move.priority || nil
      if priority > 0 || backfire
        mults[:base_damage_multiplier] *= 1.3
        user.aiLearnsAbility(ability) unless aiCheck
      end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:HARDFALL,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.pbHeight > user.pbHeight || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SCATHINGSYZYGY,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.battle.eclipsed? || backfire
      mults[:base_damage_multiplier] *= 1.25
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:BALLLIGHTNING,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      damageMult = 1.0
      if user.pbSpeed > target.pbSpeed || backfire
        speedMult = user.pbSpeed / target.pbSpeed.to_f
        speedMult = 2.0 if speedMult > 2.0
        damageMult += speedMult / 4.0
      end
      mults[:base_damage_multiplier] *= damageMult
      user.aiLearnsAbility(ability) unless aiCheck
  }
)

BattleHandlers::DamageCalcUserAbility.add(:LATEBLOOMER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if user.pbSpeed < target.pbSpeed || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:VANDAL,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if target.hasAnyItem? || backfire
      mults[:attack_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TEAMPLAYER,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      allyCount = 0
      user.eachAlly do |_b|
        allyCount += 1
      end
      mults[:attack_multiplier] *= (1 + 0.25 * allyCount)
      user.aiLearnsAbility(ability) unless aiCheck
  }
)

BattleHandlers::DamageCalcUserAbility.add(:CLEANFREAK,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      mults[:attack_multiplier] *= 1.5 if user.pbHasAnyStatus? || backfire
      user.aiLearnsAbility(ability) unless aiCheck
  }
)

BattleHandlers::DamageCalcUserAbility.add(:PUFFUP,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
      mults[:attack_multiplier] *= 1 + (0.25 * user.countEffect(:Stockpile))
      user.aiLearnsAbility(ability) unless aiCheck
  }
)

BattleHandlers::DamageCalcUserAbility.add(:WREAKHAVOC,
  proc { |ability, user, target, move, mults, _baseDmg, type, aiCheck, backfire|
    if move.rampagingMove? || backfire
      mults[:base_damage_multiplier] *= 1.3
      user.aiLearnsAbility(ability) unless aiCheck
    end
  }
)