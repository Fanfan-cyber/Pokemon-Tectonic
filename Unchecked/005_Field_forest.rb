class PokeBattle_Battle::Field_forest < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :forest
    @name                = _INTL("Forest")
    @nature_power_change = :WOODHAMMER
    @mimicry_type        = :BUG
    @camouflage_type     = :BUG
    @terrain_pulse_type  = :BUG
    @ability_activation  = %i[GRASSPELT LEAFGUARD OVERGROW SWARM]
    @secret_power_effect = 2 # sleep
    @shelter_type        = :BUG
    @field_announcement  = { :start => _INTL("The field is abound with trees."),
                             :end   => _INTL("The trees disappear from the battlefield!") }

    @multipliers = {
      [:power_multiplier, 1.5, _INTL("The forestry strengthened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[GRASS].include?(type)
      },
      [:power_multiplier, 1.5, _INTL("The attack spreads through the forest!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[BUG].include?(type) && move.specialMove?
      },
      [:power_multiplier, 2, _INTL("A tree slammed down!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[AIRCUTTER AIRSLASH BREAKINGSWIPE CUT FURYCUTTER PSYCHOCUT SLASH].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("They're coming out of the woodwork!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ATTACKORDER].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("Gossamer and arbor strengthened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ELECTROWEB].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The apple did not fall far from the tree.")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[GRAVAPPLE].include?(move.id)
      },
      [:power_multiplier, 0.5, _INTL("The forest softened the attack...")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[MUDDYWATER SURF].include?(move.id)
      },
    }

    @effects[:status_immunity] = proc { |battler, newStatus, yawn, user, show_message, self_inflicted, move, ignoreStatus|
      if (%i[SLEEP].include?(newStatus) || yawn) && battler.grounded?
        @battle.pbDisplay(_INTL("{1} can't sleep in the {2}!", battler.pbThis, @name)) if show_message
        next true
      end
    }

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
      next :GRASS if %i[AIRCUTTER AIRSLASH BREAKINGSWIPE CUT FURYCUTTER PSYCHOCUT SLASH].include?(move.id)
    }

  end
end

PokeBattle_Battle::Field.register(:forest, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Effects left to code #
# Effect Spore's activation chance is doubled to 60%. #
# Long Reach decreases the bearer's Accuracy by 0.9x. #
# Sap Sipper additionally restores 1/16 of the bearer's max HP each turn. #
# Chloroblast now deals 25% recoil damage. #
# Defend Order boosts the user's Defense and Special Defense by 2 stages. #
# Forest's Curse additionally places a Curse on the target.  #
# Growth boosts the user's Attack and Special Attack by 2 stages (does not stack with harsh sunlight effect). #
# Heal Order restores 66% of the user's max HP. #
# Infestation deals 1/6 max HP damage per turn. #
# Ingrain restores 1/8 of the user's max HP per turn. #
# Nature's Madness deals 75% HP damage. #
# Sticky Web lowers affected Pokémon's speed by 2 stages. #
# Strength Sap heals 30% more HP. #

# Transitions to other fields #
# This field will transform into Swamp Field if Surf is used 3 times or Muddy Water is used 2 times.

#    Specifically, using Surf increments the counter by +1 and using Muddy Water increments it by +2. The field changes to Swamp Field when the counter is >= 3. #
#    The ground became waterlogged... #
#    The forest became marshy! #