module DimensionD
  def self.open_dimension_d
    pkmns = $Trainer.dimension_d
    loop do
      if pkmns.empty?
        pbMessage(_INTL("You don't have any Pokémon in Dimension D!"))
        return
      else
        data = pbChoosePkmnFromListEX(_INTL("Choose a Pokémon!"), pkmns)
        pkmn = data[0]
        pkmn_index = data[1]
        return if !pkmn
        loop do
          choice = [_INTL("Take"), _INTL("Release"),  _INTL("To TC"), _INTL("Cancel")]
          choose = pbMessage(_INTL("What do you want to do?"), choice, -1)
          case choose
          when -1, 3
            break
          when 0
            if has_species?(pkmn.species, pkmn.form)
              pbMessage(_INTL("You can't retrieve this Pokémon! You already have one!"))
            else
              pbAddPokemonSilent(pkmn, count: false)
              pkmns.delete_at(pkmn_index)
              pbMessage(_INTL("You retrieved {1}!", pkmn.name))
              break
            end
          when 1
            if pbConfirmMessage(_INTL("Do you want to release {1}?", pkmn.name))
              pkmns.delete_at(pkmn_index)
              pbMessage(_INTL("You released {1}!", pkmn.name))
              break
            end
          when 2
            if pbConfirmMessage(_INTL("Do you want to put {1} in Time Capsule?", pkmn.name))
              pkmns.delete_at(pkmn_index)
              TimeCapsule.add_to_time_capsule(pkmn, true)
              break
            end
          end
        end
      end
    end
  end
end