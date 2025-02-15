PokeBattle_AI::TrainerPokemonFaintedDialogue.add(:SHADOW_MAVIS,
    proc { |_policy, battler, trainer_speaking, dialogue_array|
        battle = battler.battle
        if battle.pbTeamExhaustedButSideAlive?(battler.index) && !trainer_speaking.policyStates[:RelyOnYezeraComment]
            dialogue_array.push(_INTL("Tsk, tsk, tsk. It appears my work here is done."))
            dialogue_array.push(_INTL("Let's see which of you two is the better."))
            trainer_speaking.policyStates[:RelyOnYezeraComment] = true
        end
        next dialogue_array
    }
)

PokeBattle_AI::TrainerSendsOutPokemonDialogue.add(:SHADOW_MAVIS,
    proc { |_policy, battler, trainer_speaking, dialogue_array|
        if battler.species == :LUXRAY && !trainer_speaking.policyStates[:LuxrayComment]
            dialogue_array.push(_INTL("My pride and joy. Don't you dare fail me now. Shred mommy's enemies, OK?"))
            trainer_speaking.policyStates[:LuxrayComment] = true
        end
        next dialogue_array
    }
)

PokeBattle_AI::PlayerPokemonFaintedDialogue.add(:SHADOW_MAVIS,
    proc { |_policy, _battler, trainer_speaking, dialogue_array|
        unless trainer_speaking.policyStates[:PlayerDeathComment]
            dialogue_array.push(_INTL("...Dispose of this one after we’re done."))
            dialogue_array.push(_INTL("It doesn't deserve its position. You can do better."))
            trainer_speaking.policyStates[:PlayerDeathComment] = true
        end
        next dialogue_array
    }
)
