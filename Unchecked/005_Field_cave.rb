class PokeBattle_Battle::Field_cave < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :cave
    @name                = _INTL("Cave")
    @nature_power_change = :ROCKTOMB
    @mimicry_type        = :ROCK
    @camouflage_type     = :ROCK
    @secret_power_effect = 7 # Flinch
    @terrain_pulse_type  = :ROCK
    @shelter_type        = :ROCK # halves damage taken from rock type moves after using shelter
    @field_announcement  = { :start => _INTL("The cave echoes dully..."),
                             :end   => _INTL("The cave echoes dully...") }

    @multipliers = {
      [:power_multiplier, 1.5, _INTL("The cavern strengthened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ROCK].include?(type)
      },
      [:power_multiplier, 1.5, _INTL("...Piled on!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ROCKTOMB].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("ECHO-Echo-echo!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if move.soundMove?
      },
      [:power_multiplier, 1.3, _INTL("The cavern froze over!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[BLIZZARD].include?(move.id)
      },
      [:power_multiplier, 1.3, _INTL("The cave was littered with crystals!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[DIAMONDSTORM POWERGEM].include?(move.id)
      },
      [:power_multiplier, 1.3, _INTL("The cave was corrupted!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[SLUDGEWAVE].include?(move.id)
      },
      [:power_multiplier, 1.3, _INTL("The flame ignited the cave!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[ERUPTION FUSIONFLARE HEATWAVE LAVAPLUME OVERHEAT].include?(move.id)
      },
      [:power_multiplier, 0.5, _INTL("The cave choked out the air!")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[FLYING].include?(type)
      next if move.contactMove?
  },
}

    @effects[:no_charging] = proc { |user, move|
    next true if %i[BOUNCE FLY].include?(move.id)
 }

    @effects[:end_of_move] = proc { |user, targets, move, numHits| # threr is no difference between this and :end_of_move_universal, just separate it for different uses
    if move.id == :BLIZZARD  
    @battle.create_new_field(:icy, PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION) # this line starts a new field
  end
}

    @effects[:end_of_move] = proc { |user, targets, move, numHits| # threr is no difference between this and :end_of_move_universal, just separate it for different uses
    if %i[DIAMONDSTORM POWERGEM].include?(move.id)
    @battle.create_new_field(:icy, PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION) # Needs to be changed to Crystal Cavern when I add that field
  end
}

    @effects[:end_of_move] = proc { |user, targets, move, numHits| # threr is no difference between this and :end_of_move_universal, just separate it for different uses
    if %i[SLUDGEWAVE].include?(move.id)
    @battle.create_new_field(:icy, PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION) # Needs to be changed to corrupted when I add that field
   end
}

    @effects[:end_of_move] = proc { |user, targets, move, numHits| # threr is no difference between this and :end_of_move_universal, just separate it for different uses
    if %i[ERUPTION FUSIONFLARE HEATWAVE LAVAPLUME OVERHEAT].include?(move.id)
    @battle.create_new_field(:volcanic, PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION) # Needs to be changed to corrupted when I add that field
  end
}

  end
end

PokeBattle_Battle::Field.register(:cave, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Ground-type moves can now hit airborne Pokémon. #

# SPECIAL SECTION NEEDING WORK: CAVE COLLAPSE #
# Using any of the following moves 2 times will cause the cave to collapse, KO-ing all active Pokémon: Bulldoze, Continental Crush, Earthquake, Fissure, Magnitude, Tectonic Rage #
# Following the above: Pokémon behind a Protection move (including Wide Guard), or with the abilities Bulletproof, Rock Head, or Stalwart take no damage. #
# Following the Above: Pokémon with the abilities Prism Armor or Solid Rock take 33% max HP damage. #
# Pokémon with the abilities Battle Armor or Shell Armor take 50% max HP damage. #
# Pokémon using Endure, or with the ability Sturdy (at full HP) will survive with 1 HP. #

# MOVES #
# Sky Drop → Fails on use. #
# Stealth Rock damaged is doubled. #

# Transitions to Other Fields #
# This field will transform into Deep Earth if Gravity is used. #
#    The battle was pulled deeper into the earth! #

# This field will transform into Dragon's Den if Dragon Pulse is used 2 times, or either Devastating Drake or Draco Meteor is used 1 time. #
#    Draconic energy seeps in... #
#    The draconic energy mutated the field! #