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
        pkmn = pbChoosePkmnFromListEX(_INTL("Which Pokémon would you like to retrieve?"), allowed)
        pbAddPokemon(pkmn)
      end
    end
  end
end