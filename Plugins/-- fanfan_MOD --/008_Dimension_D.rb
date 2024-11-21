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
        pkmn = data[0]
        return if !pkmn
        pbAddPokemonSilent(pkmn, count: false)
        pkmns.delete_at(data[1])
        pbMessage(_INTL("You retrieved {1}!", pkmn.name))
      end
=begin
      data = pbChoosePkmnFromListEX(_INTL("Which Pokémon would you like to retrieve?"), pkmns)
      pkmn = data[0]
      return if !pkmn
      if has_species?(pkmn.species, pkmn.form)
        pbMessage(_INTL("You can't retrieve this Pokémon!"))
      else
        pbAddPokemonSilent(pkmn)
        pkmns.delete_at(data[1])
        pbMessage(_INTL("You retrieved {1}!", pkmn.name))
      end
=end
    end
  end
end