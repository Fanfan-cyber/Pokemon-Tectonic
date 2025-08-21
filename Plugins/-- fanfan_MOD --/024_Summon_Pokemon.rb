class PokeBattle_Battle
  def call_battler(species = nil, level = 10, sideIndex = 0, summonMessage = nil)
    return unless trainerBattle? && pbSideSize(sideIndex) == 1

    summonMessage ||= _INTL("A new ally was summoned!")
    pbDisplay(summonMessage)

    newPokemon = generatePokemon(species, level, sideIndex)

    # Put the pokemon into the party
    partyIndex = pbParty(sideIndex).length
    pbParty(sideIndex)[partyIndex] = newPokemon

    new_battler = addBattlerSlot(newPokemon, sideIndex, partyIndex)
    setBattlerProperties(new_battler)
  end

  def setBattlerProperties(battler)
    battler.applyEffect(:Summond)
  end

  def setPokemonProperties(pkmn, level, sideIndex = 0, learn_moves = true)
    pkmn.name = nil
    pkmn.owner = Owner.new(0, "", 2, 2)
    pkmn.regeneratePersonalID
    pkmn.set_used_by_player(sideIndex == 0)
    
    pkmn.level = level
    PokemonDataBase.learn_random_moves(pkmn) if learn_moves
    pkmn.calc_stats
  end

  def generatePokemon(species = nil, level = 10, sideIndex = 0)
    if species.is_a?(PokeBattle_Battler)
      newPokemon = species.pokemon.clone_pkmn(true, sideIndex == 0)
    elsif species.is_a?(Pokemon)
      newPokemon = species.clone_pkmn(true, sideIndex == 0)
    elsif species.is_a?(Symbol)
      newPokemon = Pokemon.new(species)
      setPokemonProperties(newPokemon, level, sideIndex)
    else
      newPokemon = PokemonDataBase.create_pkmn.clone_pkmn(true)
      setPokemonProperties(newPokemon, level, sideIndex, false)
    end
    newPokemon.instance_variable_set("@#{:Summond}", true)
    newPokemon.heal
    return newPokemon
  end
end