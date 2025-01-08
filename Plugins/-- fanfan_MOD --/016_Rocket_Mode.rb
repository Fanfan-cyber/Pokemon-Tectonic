module RocketMode
  def self.pbRobPokemon(battle)
    return if !$Trainer.get_ta(:rocket) || !battle.trainerBattle? || $Trainer.get_ta(:battle_loader)
    can_choose = []
    battle.pbParty(1).each_with_index do |pkmn, i|
      next if !pkmn || pkmn.egg? || has_species?(pkmn.species, pkmn.form)
      battle.peer.pbOnLeavingBattle(battle, pkmn, battle.usedInBattle[1][i], true)
      can_choose << pkmn
    end
    return if can_choose.empty?
    if pbConfirmMessage(_INTL("Do you want to take a Pokémon from the opposing party?"))
      data         = pbChoosePkmnFromListEX(_INTL("Which Pokémon do you want to take?"), can_choose, true)
      pkmn         = data[0].clone_pkmn
      pkmn.level   = getLevelCap - 5
      pkmn.ability = nil
      pkmn.reset_moves
      pkmn.items.clear
      pkmn.extraTypes.clear
      pkmn.extraAbilities.clear
      pkmn.calc_stats
      pbAddPokemon(pkmn, dexnav: true)
    end
  end
end