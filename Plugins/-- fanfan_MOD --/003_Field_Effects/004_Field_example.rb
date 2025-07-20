# I recommend that you put all effects in the same place for better organization and management,
# even though you can use is_field?(field_id) or is_xxx? for checks at any time.
class PokeBattle_Battle::Field_example < PokeBattle_Battle::Field
  def initialize(battle, duration = Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :example
    @name                = _INTL("Example Field")
    @creatable_field     = %i[beach sahara] # when this field is activate, only able to start beach or sahara, if you dont want any limit, delete this line or leave it blank
    @nature_power_change = :THUNDERBOLT # if your field doesnt have these effects, just delete the line(s) you dont want
    @mimicry_type        = :GHOST
    @camouflage_type     = :FIRE
    @ability_activation  = %i[ICEBODY SLUSHRUSH SNOWCLOAK] # support: CHLOROPHYLL FLOWERGIFT GRASSPELT ICEBODY LEAFGUARD OVERGROW SANDFORCE SANDRUSH SANDVEIL SLUSHRUSH SNOWCLOAK SWARM ZENMODE
    @secret_power_effect = 1 # paralyze
    @terrain_pulse_type  = :FLYING
    @tailwind_duration   = - 2
    @floral_heal_amount  = 2 / 3.0
    @shelter_type        = :WATER # halves damage from water type moves after using shelter
    @field_announcement  = { :start    => _INTL("The Example field is activated!"), # announcement is optional
                             :continue => _INTL("The Example field is working!"),
                             :end      => _INTL("The Example field disappeared!") }

    @multipliers = { # it accepts 2-3 arguments, first is which the multiplier is, second is the number, third is the text, the third is optional
      [:power_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ELECTRIC].include?(type) && user.grounded?
        next true if %i[GRASS FLYING].include?(type) && target.grounded?
      },
      [:power_multiplier, 0.5, _INTL("The field softened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[GROUND].include?(type) && %i[EARTHQUAKE BULLDOZE].include?(move.id)
      },
      [:defense_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[GRASS].include?(type) && target.grounded?
      },
      [:attack_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[FIRE].include?(type) && user.grounded?
      },
      [:final_damage_multiplier, 1.5, _INTL("Boom!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if target.grounded?
      },
    }

    @effects[:set_field_battle] = proc { # effects when the field starts, for example starts to rain
      @battle.pbDisplay(_INTL("The {1} made it rain!", @name))
      @battle.pbStartWeather(nil, :Rain) # tbh, start weather/terrain methods need to be refactored
    }

    @effects[:set_field_battler] = proc { |battler| # effects when the field starts(battler), for example raising stat stages
      if battler.pbHasType?(:ELECTRIC) && battler.pbCanRaiseStatStage?(:ATTACK)
        @battle.pbDisplay(_INTL("{1} gained power from the {2}!", battler.pbThis, @name))
        battler.pbRaiseStatStage(:ATTACK, 1, nil) # tbh, pbRaiseStatStage and other stat stage stuff need to be refactored
      end
    }

    @effects[:begin_battle] = proc { # effects when battle starts in this field, similar to :set_field_battle but only the first field(defaut field) will trigger
    }

    @effects[:end_field_battle] = proc { # effects when the field ends, the same as above(:set_field_battle)
    }

    @effects[:end_field_battler] = proc { |battler|
    }

    @effects[:EOR_field_battle] = proc { # end of round effects(battle)
    }

    @effects[:EOR_field_battler] = proc { |battler|
      if battler.grounded? && battler.canHeal? # end of round healing
        battler.pbRecoverHP(battler.totalhp / 16)
        @battle.pbDisplay(_INTL("{1}'s HP was restored by the {2}!", battler.pbThis, @name))
      end
    }

    @effects[:switch_in] = proc { |battler| # effects when a pkmn switches in
      if battler.isSpecies?(:PIKACHU) && battler.grounded? && battler.pbCanRaiseStatStage?(:DEFENSE)
        @battle.pbDisplay(_INTL("{1} gained power from the {2}!", battler.pbThis, @name))
        battler.pbRaiseStatStage(:DEFENSE, 2, nil)
      end
    }

    @effects[:status_immunity] = proc { |battler, newStatus, yawn, user, show_message, self_inflicted, move, ignoreStatus|
      if battler.grounded? || battler.pbHasType?(:FIRE) || yawn && battler.isSpecies?(:KYOGRE) || %i[CONFUSION].include?(newStatus)
        @battle.pbDisplay(_INTL("{1} was protected by the {2}!", battler.pbThis, @name)) if show_message
        next true
      end
    }

    @effects[:calc_speed] = proc { |battler, speed, mult|
      mult *= 1.33 if battler.hasActiveAbility?(:STATIC)
      mult *= 0.7 if battler.hasActiveAbility?(:SWIFTSWIM)
      next mult
    }

    @effects[:move_priority] = proc { |user, move, pri|
      pri += 2 if user.isSpecies?(:PIKACHU)
      next pri
    }

    @effects[:accuracy_modify] = proc { |user, target, move, modifiers, type|
      modifiers[:evasion_stage] = 0 if target.grounded? # ignore target's evasion stage
      modifiers[:accuracy_multiplier] *= 1.5 if user.pbHasType?(:WATER)
      modifiers[:evasion_multiplier] *= 0.7 if target.pbHasType?(:ELECTRIC)
      modifiers[:base_accuracy] = 0 if target.opposes?(user) # 0 means always hit
      modifiers[:base_accuracy] *= 1.5 unless target.opposes?(user)
    }

    @effects[:base_type_change] = proc { |user, move, type|
      next :FIRE if user.pbHasType?(:WATER) || user.pbHasType?(:ELECTRIC) # change move's base type to Fire
    }

    @effects[:expand_target] = proc { |user, move, move_target|
      next :AllNearFoes if user.isSpecies?(:PIKACHU) && user.grounded?
    }

    @effects[:no_charging] = proc { |user, move|
      next true if %i[PHANTOMFORCE SHADOWFORCE SOLARBEAM].include?(move.id) && user.grounded?
    }

    @effects[:no_recharging] = proc { |user, targets, move, numHits| # Hyper Beam, Shadow Half etc.
      next true if user.pbHasType?(:ELECTRIC)
    }

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
      next :FIRE if %i[QUICKATTACK].include?(move.id) # Quick Attack add a second type when calc dmg(just like Flying Press)
    }

    # INEFFECTIVE_MULTIPLIER NOT_VERY_EFFECTIVE_MULTIPLIER NORMAL_EFFECTIVE_MULTIPLIER SUPER_EFFECTIVE_MULTIPLIER
    @effects[:change_effectiveness] = proc { |effectiveness, move, moveType, defType, user, target|
      next Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if %i[THUNDERBOLT].include?(move.id) # Thunderbolt always super effective
    }

    @effects[:block_move] = proc { |move, user, target, targets, typeMod, show_message, priority|
      if !target.grounded? && target.opposes?(user) && priority > 0 # block priority move
        @battle.pbDisplay(_INTL("{1} was protected by the {2}!", target.pbThis, @name)) if show_message
        next true
      end
    }

    @effects[:block_berry] = proc { |battler| # cant eat berry
      next true if battler.pbHasType?(:FIRE) || battler.pbHasType?(:ELECTRIC)
    }

    @effects[:block_heal] = proc { |battler|
      next true unless battler.pbHasType?(:GHOST) || battler.pbHasType?(:DARK)
    }

    @effects[:block_weather] = proc { |new_weather, user, fixedDuration| # block hail
      if %i[Hail].include?(new_weather)
        @battle.pbDisplay(_INTL("The new weather can't start!"))
        next true
      end
    }

    @effects[:end_of_move_universal] = proc { |user, targets, move, numHits| # effects after using a move
    }

    @effects[:end_of_move] = proc { |user, targets, move, numHits| # threr is no difference between this and :end_of_move_universal, just separate it for different uses
      if move.id == :SPARK && user.pbCanRaiseStatStage?(:ATTACK, user, move) # raise stat stage after using Spark
        @battle.pbDisplay(_INTL("{1} gained power from the {2}!", user.pbThis, @name))
        user.pbRaiseStatStage(:ATTACK, 1, user)
        @battle.create_new_field(:beach, Battle::Field::DEFAULT_FIELD_DURATION) # this line starts a new field
      end
    }

  end
end
=begin
PokeBattle_Battle::Field.register(:example, {
  :trainer_name => [],
  :environment  => [:grass, ], # please delete :grass otherwise Example field will be activated when the backdrop/environment is grass, it also accepts "grass"/"GrAss"/:GrasS etc.
  :map_id       => [],
  :edge_type    => [],
})
=end