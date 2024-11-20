module DimensionD
  def self.open_dimension_d
    pkmns = $Trainer.dimension_d
    msg = _INTL("You don't have any Pokémon can be retrieved!")
    if pkmns.empty?
      pbMessage(msg)
    else
      allowed = []
      pkmns.each { |pkmn| allowed << pkmn if !has_species?(pkmn.species, pkmn.form) }
      if allowed.empty?
        pbMessage(msg)
      else
        data = pbChoosePkmnFromListEX(_INTL("Which Pokémon would you like to retrieve?"), allowed)
        pbAddPokemon(data[0])
        pkmns.delete_at(data[1])
      end
=begin
      data = pbChoosePkmnFromListEX(_INTL("Which Pokémon would you like to retrieve?"), pkmns)
      return if !data
      if has_species?(data[0].species, data[0].form)
        pbMessage(_INTL("You can't retrieve this Pokémon!"))
      else
        pbAddPokemon(data[0])
        pkmns.delete_at(data[1])
      end
=end
    end
  end
end