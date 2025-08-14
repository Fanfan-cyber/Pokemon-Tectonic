=begin
when :StrongWinds
  if !self.is_field?(:volcanictop) && !pbCheckGlobalAbility(:DELTASTREAM)
    @field.weather = :None
    pbDisplay("The mysterious air current has dissipated!")
  end
end
=end
class PokeBattle_Battle::Field_volcanictop2 < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :volcanictop
    @name                = _INTL("Volcanictop")
    @nature_power_change = :ERUPTION
    @mimicry_type        = :FIRE
    @camouflage_type     = :FIRE
    @terrain_pulse_type  = :FIRE
    @secret_power_effect = 10 # burn
    @tailwind_duration   = 2
    @shelter_type        = :FIRE # halves damage taken from fire type moves after using shelter
    @field_announcement  = { :start => _INTL("The mountain top is superheated."),
                             :end   => _INTL("The flames were snuffed out!") }
    @eruption_triggered = false
    @telluric_trap_users = {}

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

#Added: 100% accurate thunder
    @effects[:accuracy_modify] = proc { |user, target, move, modifiers, type|
      # Thunder never misses
      if move.id == :THUNDER
        modifiers[:base_accuracy] = 100
      end
    }

#Unsure if this works? but it should?
    @effects[:move_priority] = proc { |user, move, pri|
      # Gale Wings activation
      if user.hasActiveAbility?(:GALEWINGS) &&
         @battle.pbWeather == :StrongWinds &&
         move.type == :FLYING
        pri += 1
      end
      next pri
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

# added: moves that cause eruption.
@effects[:end_of_move] = proc { |user, targets, move, numHits|
  # Eruption-triggering moves (corrected IDs)
  if %i[BULLDOZE EARTHQUAKE EARTHPOWER ERUPTION FEVERPITCH LAVAPLUME MAGMADRIFT MAGNITUDE PRECIPICEBLADES].include?(move.id)
    @battle.pbDisplay(_INTL("The volcano is going to erupt!"))
    @eruption_triggered = true
  end

  #
  if %i[HYDROPUMP HYDROVORTEX MUDDYWATER OCEANICOPERETTA SPARKLINGARIA SURF WATERPLEDGE WATERSPOUT WATERSPORT].include?(move.id)
    battlers = [targets, user].flatten
    lowering_battlers = []
    battlers.each { |battler| lowering_battlers << battler if battler.pbCanLowerStatStage?(:ACCURACY, user, move) }
    unless lowering_battlers.empty?
      @battle.pbDisplay(_INTL("Steam shot up from the field!"))
      lowering_battlers.each { |battler| battler.pbLowerStatStage(:ACCURACY, 1, user) }
    end
  end

  # Added: Outrage/Petal Dance/Thrash fatigue
  if %i[OUTRAGE PETALDANCE THRASH].include?(move.id)
    user.effects[PBEffects::Outrage] = 0
    if user.pbCanConfuseSelf?(false)
      user.pbConfuse(_INTL("{1} collapsed from the volcanic heat!", user.pbThis))
    end
  end

  # Added: Block Raging Fury confusion
  if move.id == :RAGINGFURY
    user.effects[PBEffects::Confusion] = 0
  end
}

#Added: Eruption logic
    @effects[:EOR_field_battle] = proc {
  desolate_land = @battle.allBattlers.any? { |b| b.hasActiveAbility?(:DESOLATELAND) }
  eruption_happens = @eruption_triggered || desolate_land

  if eruption_happens
        # Display eruption message
        if desolate_land
          @battle.pbDisplay(_INTL("The Desolate Land causes the volcano to erupt!"))
        else
          @battle.pbDisplay(_INTL("The volcano erupts!"))
        end

        # Damage calculation
        @battle.allBattlers.each do |battler|
          next if battler.fainted?
          
          # Check immunities
          immune = false
          immune_reason = ""
          
          # Move-based protections
          if battler.effects[PBEffects::AquaRing] || battler.effects[PBEffects::WideGuard]
            immune = true
            immune_reason = _INTL("protective move")
          end
          
          # Ability immunities
          immune_abilities = [:BATTLEARMOR, :BLAZE, :FLAREBOOST, :FLAMEBODY, :FLASHFIRE,
                             :MAGICGUARD, :MAGMAARMOR, :PRISMARMOR, :SHELLARMOR,
                             :SOLIDROCK, :STURDY, :WATERBUBBLE, :WONDERGUARD]
          if immune_abilities.any? { |ability| battler.hasActiveAbility?(ability) }
            immune = true
            immune_reason = _INTL("{1}", battler.abilityName)
          end
          
          # Type immunity
          if battler.pbHasType?(:FIRE)
            immune = true
            immune_reason = _INTL("Fire typing")
          end

          if immune
            @battle.pbDisplay(_INTL("{1} is immune to the eruption! ({2})", battler.pbThis, immune_reason))
            next
          end

          # Calculate damage
          type_mod = Effectiveness::NORMAL_EFFECTIVE
          battler.pbTypes(true).each do |type|
            mod = Effectiveness.calculate(:FIRE, type)
            type_mod *= mod
          end
          next if type_mod == 0

          # Tar Shot multiplier
          damage_multiplier = 1.0
          if battler.effects[PBEffects::TarShot]
            damage_multiplier = 2.0
            @battle.pbDisplay(_INTL("The sticky tar intensifies the heat!"))
          end

          base_damage = (battler.totalhp / 8.0) * damage_multiplier
          damage = (base_damage * type_mod.to_f / Effectiveness::NORMAL_EFFECTIVE).floor
          
          if damage > 0
            battler.pbReduceHP(damage, true)
            @battle.pbDisplay(_INTL("{1} is hurt by the eruption!", battler.pbThis))
          end
        end

        # Wake sleeping Pokémon
        @battle.allBattlers.each do |battler|
          next unless battler.status == :SLEEP && !battler.hasActiveAbility?(:SOUNDPROOF)
          battler.pbCureStatus(false)
          @battle.pbDisplay(_INTL("{1} woke up due to the eruption!", battler.pbThis))
        end

        # Clear hazards
        hazards_cleared = false
        @battle.sides.each do |side|
          if side.effects[PBEffects::Spikes] > 0 ||
             side.effects[PBEffects::ToxicSpikes] > 0 ||
             side.effects[PBEffects::StealthRock]
            side.effects[PBEffects::Spikes]       = 0
            side.effects[PBEffects::ToxicSpikes]  = 0
            side.effects[PBEffects::StealthRock]  = false
            hazards_cleared = true
          end
        end
        @battle.pbDisplay(_INTL("The eruption removed all hazards from the field!")) if hazards_cleared

        # Clear Leech Seed
        @battle.allBattlers.each do |battler|
          if battler.effects[PBEffects::LeechSeed] >= 0
            battler.effects[PBEffects::LeechSeed] = -1
            @battle.pbDisplay(_INTL("{1}'s Leech Seed burned away in the eruption!", battler.pbThis))
          end
        end

        # Ability activations
        @battle.allBattlers.each do |battler|
          next if battler.fainted?
          
          # Flash Fire activation
          if battler.hasActiveAbility?(:FLASHFIRE)
            @battle.pbDisplay(_INTL("{1}'s Flash Fire activated!", battler.pbThis))
            battler.effects[PBEffects::FlashFire] = true
          end
          
          # Magma Armor effects
          if battler.hasActiveAbility?(:MAGMAARMOR)
            @battle.pbDisplay(_INTL("{1}'s Magma Armor hardened!", battler.pbThis))
            battler.pbRaiseStatStage(:DEFENSE, 1, battler)
            battler.pbRaiseStatStage(:SPECIAL_DEFENSE, 1, battler)
          end
          
          # Flare Boost activation
          if battler.hasActiveAbility?(:FLAREBOOST)
            @battle.pbDisplay(_INTL("{1}'s Flare Boost activated!", battler.pbThis))
            battler.pbRaiseStatStage(:SPECIAL_ATTACK, 1, battler)
          end
        end

        @eruption_triggered = false
      end
    }

#Added: Burn up logic
@effects[:EOR_field_battler] = proc { |battler|
  # Reset Burn Up's Fire type removal
  if battler.effects[PBEffects::BurnUp]
    battler.effects[PBEffects::BurnUp] = false
    battler.pbUpdate(true)
    @battle.pbDisplay(_INTL("{1}'s Fire type was restored!", battler.pbThis))
  end
}

#"added": block hail
@effects[:block_weather] = proc { |new_weather, user, fixedDuration|
  next unless new_weather == :Hail

  if user&.hasActiveAbility?(:SNOWWARNING)
      battle.pbShowAbilitySplash(battler)
    @battle.pbDisplay(_INTL("The hail melted away.")) do
      battle.pbHideAbilitySplash(battler)
    end
    
    next true
  else
    @battle.pbDisplay(_INTL("The hail melted away."))
    next true
  end
}

#Added: Poison Gas inflicts toxic effect
@effects[:status_immunity] = proc { |battler, newStatus, yawn, user, show_message, self_inflicted, move, ignoreStatus|
  # Force Poison Gas to inflict bad poison with animation
  if newStatus == :POISON && move&.id == :POISONGAS
    @battle.pbAnimation(:POISONGAS, user, battler) # Add this line
    battler.pbPoison(user, _INTL("{1} was badly poisoned by the volcanic gases!", battler.pbThis), true)
    next true
  end
}

#Added: Smokescreen -2 accuracy
@effects[:block_move] = proc { |move, user, target, targets, typeMod, show_message, priority|
  next false unless move.id == :SMOKESCREEN

  # Play original animation
  @battle.pbAnimation(:SMOKESCREEN, user, target) # Use move ID to trigger animation

  # Custom effect
  targets.each do |b|
    next if b.damageState.unaffected || b.damageState.substitute
    b.pbLowerStatStage(:ACCURACY, 2, user, show_message)
  end

  next true # Block original move logic
}

#Added: fire damage stealth rock
@effects[:switch_in] = proc { |battler|
  # Existing switch-in effects

  # Fire-type Stealth Rock override
  if battler.pbOwnSide.effects[PBEffects::StealthRock] && battler.takesIndirectDamage? &&
     !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
    bTypes = battler.pbTypes(true)
    eff = Effectiveness.calculate(:FIRE, *bTypes)
    if !Effectiveness.ineffective?(eff)
      # Get valid animation user (first non-fainted battler)
      animUser = @battle.allBattlers.find { |b| !b.fainted? && b.opposes?(battler) } || battler
      
      # Play animation (may be removed i believe)
      @battle.pbAnimation(:EARTHPOWER, animUser, battler)
      
      # Calculate and apply damage
      hpLoss = battler.totalhp * eff / 8
      battler.pbReduceHP(hpLoss, false)
      @battle.pbDisplay(_INTL("Searing flames engulfed {1}!", battler.pbThis))
      battler.pbItemHPHealCheck
      
      # Block original Stealth Rock
      battler.pbOwnSide.effects[PBEffects::StealthRock] = false
    end
  end
}

#Added: Strongwinds with tailwind
    @effects[:tailwind_duration] = proc { |user, move|
      # Start Strong Winds weather lasting 6 turns
      @battle.pbStartWeather(user, :StrongWinds, 6, false)
      next @tailwind_duration  # Return the duration addition
    }

  end
end


PokeBattle_Battle::Field.register(:volcanictop2, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})