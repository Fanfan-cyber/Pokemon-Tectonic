class PokeBattle_Battle::Field_city < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :city
    @name                = _INTL("City")
    @nature_power_change = :SMOG
    @mimicry_type        = :NORMAL
    @camouflage_type     = :NORMAL
    @terrain_pulse_type  = :NORMAL
    @secret_power_effect = 2 # need to change to poison
    @shelter_type        = :NORMAL
    @field_announcement  = { :start => _INTL("The streets are busy..."),
                             :end   => _INTL("The street is cleared!") }

    @multipliers = {
      [:power_multiplier, 1.3, _INTL("In the cracks and the walls!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[BUG].include?(type)
      },
      [:power_multiplier, 1.5, _INTL("The hustle and bustle of the city!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[NORMAL].include?(type) && move.physicalMove?
    },
      [:power_multiplier, 1.3, _INTL("All kinds of pollution strengthened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[POISON].include?(type)
      },
      [:power_multiplier, 1.3, _INTL("The right tool for the job!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[STEEL].include?(type)
      },
      [:power_multiplier, 0.7, _INTL("This is no place for fairytales...")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[FAIRY].include?(type)
      },
      [:power_multiplier, 1.5, _INTL("An overwhelming first impression!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[FIRSTIMPRESSION].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("A crowd is gathering!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[BEATUP].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("Working 9 to 5 for this!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[PAYDAY].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The city smog is suffocating!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[SMOG].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("Careful on the street!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[STEAMROLLER].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The power of science is amazing!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[TECHNOBLAST].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The criminal ran into a backalley!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[COVET PURSUIT THIEF].include?(move.id)
    },
      [:power_multiplier, 0.5, _INTL("The city is no place for a family!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[POPULATIONBOMB].include?(move.id)
      },
    }

    @effects[:switch_in] = proc { |battler|
    if battler.hasActiveAbility?(:BIGPECKS)
      @battle.pbDisplay(_INTL("{1} Big Pecks raise its Defense!", battler.pbThis, @name))
      battler.pbRaiseStatStage(:DEFENSE, 1, nil)
    end
  }

  @effects[:switch_in] = proc { |battler|
  if battler.hasActiveAbility?(:EARLYBIRD)
    @battle.pbDisplay(_INTL("The early bird catches the worm!", battler.pbThis, @name))
    battler.pbRaiseStatStage(:ATTACK, 1, nil)
  end
}

@effects[:switch_in] = proc { |battler|
if battler.hasActiveAbility?(:PICKUP)
  @battle.pbDisplay(_INTL("{1} is picking up Speed!!", battler.pbThis, @name))
  battler.pbRaiseStatStage(:SPEED, 1, nil)
end
}

@effects[:switch_in] = proc { |battler|
if battler.hasActiveAbility?(:RATTLED)
  @battle.pbDisplay(_INTL("The busy city is rattling!", battler.pbThis, @name))
  battler.pbRaiseStatStage(:SPEED, 1, nil)
end
}

@effects[:switch_in] = proc { |battler|
if battler.hasActiveAbility?(:DOWLOAD)
  @battle.pbDisplay(_INTL("Free Wifi!", battler.pbThis, @name))
  battler.pbRaiseStatStage(:ATTACK, 3, nil)
end
}

@effects[:switch_in] = proc { |battler|
if battler.hasActiveAbility?(:FRISK)
  @battle.pbDisplay(_INTL("Just a routine inspection.", battler.pbThis, @name))
  target.pbLowerStatStage(:SPECIALDEFENSE, 1, nil)
end
}

  Battle::AbilityEffects::OnStatLoss.add(:COMPETITIVE,
  proc { |ability, user, target, move, battle|
  if battle.is_city?
  user.pbRaiseStatStageByAbility(:SPECIALATTACK, 3, target, true, true)
  end
 }
)

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
      next :NORMAL if %i[FIRSTIMPRESSION].include?(move.id)
    }

    @effects[:end_of_move] = proc { |user, targets, move, numHits| # threr is no difference between this and :end_of_move_universal, just separate it for different uses
    if %i[COVET PURSUIT THIEF].include?(move.id)
    @battle.create_new_field(:icy, Battle::Field::DEFAULT_FIELD_DURATION) # Needs to be changed to back alley when I add that field
   end
}

@effects[:accuracy_modify] = proc { |user, target, move, modifiers, type|
modifiers[:base_accuracy] = 0 if %i[POISONGAS SMOG].include?(move.id)
}

  end
end

PokeBattle_Battle::Field.register(:city, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Hustle now boosts damage by 75%, but lowers accuracy by 33%. #
# Stench's activation chance is doubled to 20%. #
# Corrosive Gas additionally lowers all of the target's stats by 1 stage. #
# Poison Gas and Smog and inflict Bad Poison to the target. #
# Recycle additionally boosts a random stat of the user by 1 stage if successful.  #

