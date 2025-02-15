PokeBattle_AI::TrainerSendsOutPokemonDialogue.add(:ALTERNATE_TAMARIND,
  proc { |_policy, battler, trainer_speaking, dialogue_array|
      if battler.species == :MEWTWO && !trainer_speaking.policyStates[:MewtwoComment]
          dialogue_array.push(_INTL("You know the plan. My dear friend, dismantle them."))
          dialogue_array.push(_INTL("Show them why you’re the god of this place!"))
          trainer_speaking.policyStates[:MewtwoComment] = true
      end
      next dialogue_array
  }
)
