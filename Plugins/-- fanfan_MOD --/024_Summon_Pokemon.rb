class PokeBattle_Battle
  def call_battler(species, level, sideIndex = 0, pokemon = nil, random = false, summonMessage = nil)
    return unless trainerBattle? && singleBattle?

    summonMessage ||= _INTL("A new ally was summoned!")
    pbDisplay(summonMessage)

    newPokemon = generatePokemon(species, level, true, sideIndex, pokemon, random)

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

  def generatePokemon(species, level, summon = false, sideIndex = 0, pokemon = nil, random = false)
    if pokemon
      newPokemon = pokemon.clone_pkmn(true, sideIndex == 0)
    elsif random
      newPokemon = PokemonDataBase.create_pkmn
      setPokemonProperties(newPokemon, level, sideIndex, false)
    else
      newPokemon = Pokemon.new(species, level)
      setPokemonProperties(newPokemon, level, sideIndex)
    end
    newPokemon.instance_variable_set("@#{:Summond}", true)

    # Add the form name to the end of their name
    # If the pokemon's form was specified in its species id
    speciesForm = GameData::Species.get(newPokemon.species)
    newPokemon.name += " " + speciesForm.form_name if speciesForm.form != 0

    # Set the pokemon's starting health if its a low-level summon
    if summon
      if level >= SUMMON_MAX_HEALTH_LEVEL
        healthPercent = 1.0
      elsif level <= SUMMON_MIN_HEALTH_LEVEL
        healthPercent = 0.4
      else
        healthPercent = 0.4 + 0.6 * (level - SUMMON_MIN_HEALTH_LEVEL) / (SUMMON_MAX_HEALTH_LEVEL - SUMMON_MIN_HEALTH_LEVEL).to_f
        echoln("Summoning #{species} at health fraction #{healthPercent}")
      end
      newPokemon.hp = (newPokemon.totalhp * healthPercent).ceil
    end

    return newPokemon
  end
end