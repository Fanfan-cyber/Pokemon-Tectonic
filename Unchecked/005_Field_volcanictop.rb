class PokeBattle_Battle::Field_volcanictop < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :volcanictop
    @name                = _INTL("Volcanictop")
    @nature_power_change = :ERUPTION
    @mimicry_type        = :FIRE
    @camouflage_type     = :FIRE
    @terrain_pulse_type  = :FIRE
    @secret_power_effect = 10 # burn
    @tailwind_duration   = - 6
    @shelter_type        = :FIRE # halves damage taken from fire type moves after using shelter
    @field_announcement  = { :start => _INTL("The mountain top is superheated."),
                             :end   => _INTL("The flames were snuffed out!") }

    @multipliers = {
    [:power_multiplier, 1.2, _INTL("The attack was super-heated!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[FIRE].include?(type)
    },
    [:power_multiplier, 0.5, _INTL("The extreme heat softened the attack...")] => proc { |user, target, numTargets, move, type, power, mults|
      next true if %i[ICE].include?(type)
    },
    [:power_multiplier, 0.9, _INTL("The extreme heat softened the attack...")] => proc { |user, target, numTargets, move, type, power, mults|
    next true if %i[WATER].include?(type)
    },
    [:power_multiplier, 1.5, _INTL("The field super-heated the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
    next true if %i[CLEARSMOG GUST ICYWIND OMINOUSWIND RAZORWIND PRECIPICEBLADES SILVERWIND SMOG TWISTER].include?(move.id)
    },
    [:power_multiplier, 1.5, _INTL("The field powers up the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
    next true if %i[THUNDER].include?(move.id)
    },
    [:power_multiplier, 1.5, _INTL("The field powers up the flaming attacks!")] => proc { |user, target, numTargets, move, type, power, mults|
    next true if %i[INFERNALPARADE].include?(move.id)
    },
    [:power_multiplier, 1.5, _INTL("The field super-heated the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
    next true if %i[SCALD STEAMERUPTION].include?(move.id)
   },
    [:power_multiplier, 1.3, _INTL("The field powers up the flaming attacks!")] => proc { |user, target, numTargets, move, type, power, mults|
    next true if %i[ERUPTION HEATWAVE LAVAPLUME MAGMASTORM].include?(move.id)
    },
    [:power_multiplier, 0.625] => proc { |user, target, numTargets, move, type, power, mults|
    next true if %i[HYDROPUMP HYDROVORTEX MUDDYWATER OCEANICOPERETTA SPARKLINGARIA SURF WATERPLEDGE WATERSPOUT WATERSPORT].include?(move.id) 
    },
  }

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
  next :FIRE if %i[ROCK].include?(type)
  }

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
  next :FIRE if %i[CLEARSMOG GUST ICYWIND OMINOUSWIND RAZORWIND PRECIPICEBLADES SILVERWIND SMOG TWISTER DIG DIVE EGGBOMB EXPLOSION MAGNETBOMB SEISMICTOSS SELFDESTRUCT].include?(move.id)
  }

    @effects[:EOR_field_battler] = proc { |battler|
  if battler.hasActiveAbility?(:STEAMENGINE) && battler.pbCanRaiseStatStage?(:SPEED)
  @battle.pbDisplay(_INTL("The heat is powerning the steam engine!", battler.pbThis, @name))
  battler.pbRaiseStatStage(:DEFENSE, 1, nil)
  end
  }

  @effects[:end_of_move] = proc { |user, targets, move, numHits|
  if %i[HYDROPUMP HYDROVORTEX MUDDYWATER OCEANICOPERETTA SPARKLINGARIA SURF WATERPLEDGE WATERSPOUT WATERSPORT].include?(move.id) 
    battlers = [targets, user].flatten
    lowering_battlers = []
    battlers.each { |battler| lowering_battlers << battler if battler.pbCanLowerStatStage?(:ACCURACY, user, move) }
    next if lowering_battlers.empty?
    @battle.pbDisplay(_INTL("Steam shot up from the field!"))
    lowering_battlers.each { |battler| battler.pbLowerStatStage(:ACCURACY, 1, user) }
  end
}

  end
end


PokeBattle_Battle::Field.register(:volcanictop, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Mountain will transform into this field if one of the moves Eruption, Inferno Overdrive, Lava Plume, or Magma Drift is used.
# The mountain erupted!
# Snowy Mountain will transform into this field if either of the moves Eruption or Magma Drift is used.
# The mountain erupted!
# Infernal Field will transform into this field if one of the moves Judgment, Origin Pulse, or Purify is used.
# The hellish landscape was purified!

# Bulldoze, Earthquake, Earth Power, Eruption, Fever Pitch, Lava Plume, Magma Drift, Magnitude, Precipice Blades - all cause eruption
# The ability Desolate Land causes an eruption at the end of each turn.
# Pokémon are immune to the eruption if they are under the effects of Aqua Ring, or Wide Guard, or have one of the following abilities:
# Battle Armor, Blaze, Flare Boost, Flame Body, Flash Fire, Magic Guard, Magma Armor, Prism Armor, Shell Armor, Solid Rock, Sturdy, Water Bubble, Wonder Guard
# Pokémon affected by Tar Shot take x2 damage from the eruption.

# The following abilities will activate after an eruption:
# Blaze and Flash Fire are activated.
# Magma Armor boosts the bearer's Defense and Special Defense by 1 stage, and makes the bearer immune to Fire-type moves.
# Flare Boost boosts the bearer's Special Attack by 1 stage.
# Sleeping Pokémon are woken up after an eruption, unless they have the ability Soundproof. 
# The field is cleared of hazards and Leech Seed after an eruption. 

# Gale Wings is always activated if Strong Winds are blowing.
# Ice Face melts on switch-in.
# Burn Up's effect resets at the end of the turn.
# Outrage, Petal Dance, and Thrash now cause fatigue after 1 turn.
# Poison Gas now inflicts badly poisoned status.
# Raging Fury does not Confuse.
# Smokescreen lowers the target's Accuracy by 2 stages.
# Stealth Rock deals Fire-type damage instead.
# Tailwind lasts 6 turns and creates Strong Winds for its duration.
#Any move in this section inherently gains a 1.3x damage boost if it changes the field, unless noted otherwise.

    #This field will transform into Sky Field if either Bounce or Fly is used.
      #  The battle was taken to the skies!
   # This field will transform into Mountain if one of the moves Blizzard, Glaciate is used.
    #    The field cooled off!