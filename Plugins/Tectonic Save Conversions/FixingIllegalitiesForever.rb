# SaveData.register_conversion(:fix_pokemon_illegalities) do
#     game_version Settings::GAME_VERSION
#     display_title 'Finding and fixing illegal elements on all owned Pokemon.'
#     to_all do |save_data|
#       removeIllegalElementsFromAllPokemon(save_data)
#     end
# end

def skipLegalityMessages?
  return $DEBUG
end

  def moveLegalOnPokemon?(moveID, pokemon, location = nil, source = nil)
    moveData = GameData::Move.get(moveID)
    name = pokemon.name
    name = "#{name} (#{pokemon.species_data.name})" if pokemon.nicknamed?
    if pokemon.species == :SMEARGLE
        if moveData.cut
            pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has move {3} in its move list. That move has been cut from the game or is not legal to learn. Removing now.", name, location, moveData.name)) if location && !skipLegalityMessages? && !source
            return false
        end
    else
        if !moveData.learnable?
            pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has move {3} in its move list. That move has been cut from the game or is not legal to learn. Removing now.", name, location, moveData.name)) if location && !skipLegalityMessages? && !source
            return false
        end
      
        if !pokemon.learnable_moves(false).include?(moveID)
            pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has move {3} in its move list. That move is not legal for its species. Removing now.", name, location, moveData.name)) if location && !skipLegalityMessages? && !source
            return false
        end
    end
    return true
  end

  def removeIllegalElementsFromAllPokemon(save_data, source = nil)
    anyPokemonChanged = false

    (source || method(:eachPokemonInSave)).call(*(source ? [] : [save_data])) do |pokemon, location|  
      name = pokemon.name
      name = "#{name} (#{pokemon.species_data.name})" if pokemon.nicknamed?
  
      # Find and remove illegal moves from movesets
      movesToRemoveFromMoveset = []
      pokemon.moves.each do |move|
        next if move.nil?
        moveID = move.id
        next if moveLegalOnPokemon?(moveID,pokemon,location,source)
        movesToRemoveFromMoveset.push(moveID)
      end
      movesToRemoveFromMoveset.each do |moveID|
        pokemon.forget_move(moveID)
        anyPokemonChanged = true
      end

      # Find and remove illegal moves from the "first moves" list
      movesToRemoveFromFirst = []
      pokemon.first_moves.each do |moveID|
        next if moveID.nil?
        next if moveLegalOnPokemon?(moveID,pokemon,nil,source)
        movesToRemoveFromFirst.push(moveID)
      end
      movesToRemoveFromFirst.each do |moveID|
        pokemon.remove_first_move(moveID)
        anyPokemonChanged = true
      end

      # Find and fix illegal abilities
=begin
      unless pokemon.species_data.legalAbilities.include?(pokemon.ability_id)
        if pokemon.ability.nil?
          pokemon.recalculateAbilityFromIndex
          newAbilityName = pokemon.ability.name
          pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has no ability. Switching to {3}.", name, location, newAbilityName)) unless skipLegalityMessages? || source
        else
          oldAbilityName = pokemon.ability.name
          pokemon.recalculateAbilityFromIndex
          newAbilityName = pokemon.ability.name
          pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has ability {3}. That ability is not legal for its species. Switching to {4}.", name, location, oldAbilityName, newAbilityName)) unless skipLegalityMessages? || source
        end
        anyPokemonChanged = true
      end
=end
        if pokemon.ability.nil?
          pokemon.recalculateAbilityFromIndex
          newAbilityName = pokemon.ability.name
          pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has no ability. Switching to {3}.", name, location, newAbilityName)) unless skipLegalityMessages? || source
          anyPokemonChanged = true
        else
          if pokemon.ability.cut || pokemon.ability.primeval || (pokemon.ability.is_uncopyable_ability? && !pokemon.species_abilities.include?(pokemon.ability_id))
            oldAbilityName = pokemon.ability.name
            pokemon.recalculateAbilityFromIndex
            newAbilityName = pokemon.ability.name
            pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has ability {3}. That ability is not legal for its species. Switching to {4}.", name, location, oldAbilityName, newAbilityName)) unless skipLegalityMessages? || source
            anyPokemonChanged = true
          end
        end

      # Check and remove illegal items
      pokemon.items.clone.each do |item|
        itemData = GameData::Item.get(item)
        next if itemData.legal?
        pbMessage(_INTL("\\l[4]Pokemon {1} in {2} has item {3}. That item has been cut from the game or is not legal to own. Removing now.", name, location, itemData.name)) unless skipLegalityMessages? || source
        pokemon.removeItem(item)
        anyPokemonChanged = true
      end
    end
    return anyPokemonChanged
  rescue StandardError
    pbMessage(_INTL("An error occured while checking for the legality of your party."))
    pbPrintException($!)
    return false
  end
  