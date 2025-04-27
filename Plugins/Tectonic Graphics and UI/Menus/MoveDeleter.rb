def moveDeletion(pokemon)
  pbMessage(_INTL("Which move should be forgotten?"))
  pbChooseMove(pokemon, 2, 4)
  chosenMoveIndex = pbGet(2)
  if chosenMoveIndex >= 0
    chosenMove = pokemon.moves[chosenMoveIndex]
    if pbConfirmMessageSerious(_INTL("Are you sure you want {1} to forget {2}?",pokemon.name,chosenMove.name))
      pbPlayDecisionSE
      pokemon.forget_move_at_index(chosenMoveIndex)
      pbMessage(_INTL("Success! {1} forget {2} completely.",pokemon.name,chosenMove.name))
    end
  end
end