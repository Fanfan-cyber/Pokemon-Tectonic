RENAMES_1_11 = {
  :LAPNESSIE => :SAURENAID,
  :ZWEIHANDOR => :REAVOR,
}

SaveData.register_conversion(:species_renaming_1_11) do
  game_version '1.11.0'
  display_title '1.11.0 species renames'
  to_all do |save_data|
    eachPokemonInSave(save_data) do |pokemon,_location|
      next if !RENAMES_1_11.has_key?(pokemon.species)
      pokemon.species = RENAMES_1_11[pokemon.species]
    end
  end
end

def eachPokemonInSave(save_data)
  save_data[:player].party.each do |pokemon|
    yield pokemon, _INTL("your party")
  end 
  storage = save_data[:storage_system]

  for i in -1...storage.maxBoxes
    for j in 0...storage.maxPokemon(i)
      pokemon = storage.boxes[i][j]
      yield pokemon, _INTL("storage box {1}", i) if pokemon
    end
  end

  TimeCapsule.each_pokemon(true) { |pokemon| yield pokemon, _INTL("the Time Capsule") }
end