PokeBattle_AI::TrainerSendsOutPokemonDialogue.add(:ALTERNATE_ZAIN,
  proc { |_policy, battler, trainer_speaking, dialogue_array|
      if battler.species == :GIRATINA && !trainer_speaking.policyStates[:GiratinaComment]
          dialogue_array.push(_INTL("Yes, my lord. The battle is ready for your presence."))
          trainer_speaking.policyStates[:GiratinaComment] = true
      end
      next dialogue_array
  }
)
