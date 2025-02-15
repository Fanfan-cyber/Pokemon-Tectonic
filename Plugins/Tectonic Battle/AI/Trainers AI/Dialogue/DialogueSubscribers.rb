#===============================================================================
# TrainerChoseMoveDialogue handlers
#===============================================================================
PokeBattle_AI::TrainerChoseMoveDialogue.add(:DEBUG,
  proc { |_policy, _battler, _move, _target, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:TrainerChoseMoveDEBUG]
          dialogue_array.push(_INTL("I chose a move!"))
          trainer_speaking.policyStates[:TrainerChoseMoveDEBUG] = true
      end
      next dialogue_array
  }
)

#===============================================================================
# PlayerChoseMoveDialogue handlers
#===============================================================================
PokeBattle_AI::PlayerChoseMoveDialogue.add(:DEBUG,
  proc { |_policy, _battler, _move, _target, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:PlayerChoseMoveDEBUG]
          dialogue_array.push(_INTL("You chose a move!"))
          trainer_speaking.policyStates[:PlayerChoseMoveDEBUG] = true
      end
      next dialogue_array
  }
)

#===============================================================================
# TrainerPokemonFaintedDialogue handlers
#===============================================================================
PokeBattle_AI::TrainerPokemonFaintedDialogue.add(:DEBUG,
  proc { |_policy, _battler, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:TrainerPokemonFaintedDEBUG]
          dialogue_array.push(_INTL("My Pokémon fainted!"))
          trainer_speaking.policyStates[:TrainerPokemonFaintedDEBUG] = true
      end
      next dialogue_array
  }
)

#===============================================================================
# PlayerPokemonFaintedDialogue handlers
#===============================================================================
PokeBattle_AI::PlayerPokemonFaintedDialogue.add(:DEBUG,
  proc { |_policy, _battler, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:PlayerPokemonFaintedDEBUG]
          dialogue_array.push(_INTL("Your Pokémon fainted!"))
          trainer_speaking.policyStates[:PlayerPokemonFaintedDEBUG] = true
      end
      next dialogue_array
  }
)

#===============================================================================
# TrainerSendsOutPokemonDialogue handlers
#===============================================================================
PokeBattle_AI::TrainerSendsOutPokemonDialogue.add(:DEBUG,
  proc { |_policy, _battler, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:TrainerSendsOutPokemonDEBUG]
          dialogue_array.push(_INTL("I sent out a Pokémon!"))
          trainer_speaking.policyStates[:TrainerSendsOutPokemonDEBUG] = true
      end
      next dialogue_array
  }
)

#===============================================================================
# PlayerSendsOutPokemonDialogue handlers
#===============================================================================
PokeBattle_AI::PlayerSendsOutPokemonDialogue.add(:DEBUG,
  proc { |_policy, _battler, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:PlayerSendsOutPokemonDEBUG]
          dialogue_array.push(_INTL("You sent out a Pokémon!"))
          trainer_speaking.policyStates[:PlayerSendsOutPokemonDEBUG] = true
      end
      next dialogue_array
  }
)

PokeBattle_AI::PlayerSendsOutPokemonDialogue.add(:REMARKONSTARTER,
  proc { |_policy, battler, trainer_speaking, dialogue_array|
      next dialogue_array unless %i[BOUNSWEET NUMEL KRABBY].include?(battler.species)
      unless trainer_speaking.policyStates[:RemarkedOnStarter]
          dialogue_array.push(_INTL("Wow, I've never seen that Pokémon before!"))
          dialogue_array.push(_INTL("I'm gonna check my !"))
          case battler.species
          when :BOUNSWEET
              dialogue_array.push(_INTL("Bounsweet, it says. Playful, but a little dangerous!"))
          when :NUMEL
              dialogue_array.push(_INTL("Numel, huh? Fire-type--hope I don't get burned!"))
          when :KRABBY
              dialogue_array.push(_INTL("Krabby... a Water-type... with massive attack power, wow!"))
          end
          trainer_speaking.policyStates[:RemarkedOnStarter] = true
      end
      next dialogue_array
  }
)

#===============================================================================
# TrainerPokemonTookMoveDamageDialogue handlers
#===============================================================================
PokeBattle_AI::TrainerPokemonTookMoveDamageDialogue.add(:DEBUG,
  proc { |_policy, _dealer, _taker, _move, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:TrainerPokemonTookMoveDamageDEBUG]
          dialogue_array.push(_INTL("My Pokémon took move damage!"))
          trainer_speaking.policyStates[:TrainerPokemonTookMoveDamageDEBUG] = true
      end
      next dialogue_array
  }
)

#===============================================================================
# PlayerPokemonTookMoveDamageDialogue handlers
#===============================================================================
PokeBattle_AI::PlayerPokemonTookMoveDamageDialogue.add(:DEBUG,
  proc { |_policy, _dealer, _taker, _move, trainer_speaking, dialogue_array|
      unless trainer_speaking.policyStates[:PlayerPokemonTookMoveDamageDEBUG]
          dialogue_array.push(_INTL("Your Pokémon took move damage!"))
          trainer_speaking.policyStates[:PlayerPokemonTookMoveDamageDEBUG] = true
      end
      next dialogue_array
  }
)
