module DeoxysExtraMoves
  def self.learnExtraMove(pokemon)
    loop do
      ret = pbMessage(_INTL("What do you want to do?"), [_INTL("Learn Move"),  _INTL("Check Move"), _INTL("Cancel")], -1)
      break if [-1, 2].include?(ret)
      species = pokemon.species
      form1Name = GameData::Species.get_species_form(species, 1).form_name
      form2Name = GameData::Species.get_species_form(species, 2).form_name
      form3Name = GameData::Species.get_species_form(species, 3).form_name
      choices = [form1Name, form2Name, form3Name, _INTL("Cancel")]
      case ret
      when 0
        loop do
          choice = pbMessage(_INTL("Which form?"), choices, -1)
          break if [-1, 3].include?(choice)
          move = pbChooseMoveListForSpecies(species, nil, true, move_list: pokemon.level_moves)
          break unless move
          form = choice + 1
          pokemon.initializeExtraMoves
          pblearnExtraMove(pokemon, form, move)
        end
      when 1
        loop do
          choice = pbMessage(_INTL("Which form?"), choices, -1)
          break if [-1, 3].include?(choice)
          form = choice + 1
          pokemon.initializeExtraMoves
          moves = pokemon.moves_for_dexyos[form].map(&:name)
          form_name = choices[choice]
          if pokemon.numExtraMoves(form) > 1
            pbMessage(_INTL("{1} form {2}'s moves are {3}.", form_name, pokemon.name, moves.quick_join))
          else
            pbMessage(_INTL("{1} form {2}'s move is {3}.", form_name, pokemon.name, moves.quick_join))
          end
        end
      end
    end
  end
end

def pblearnExtraMove(pkmn, form, move, ignoreifknown = false, bymachine = false, &block)
  return false unless pkmn
  if pkmn.egg? && !$DEBUG
    pbMessage(_INTL("Eggs can't be taught any moves."), &block)
    return false
  end
  move = GameData::Move.get(move)
  move_id = move.id
  move_name = move.name
  pkmn_name = pkmn.name
  if pkmn.hasExtraMove?(form, move_id)
    pbMessage(_INTL("{1} already knows {2}.", pkmn_name, move_name), &block) unless ignoreifknown
    return false
  end
  if pkmn.numExtraMoves(form) < Pokemon::MAX_MOVES
    pkmn.learn_extra_move(form, move_id)
    pbMessage(_INTL("\\se[]{1} learned {2}!\\se[Pkmn move learnt]", pkmn_name, move_name), &block)
    return true
  end
  moves = pkmn.moves_for_dexyos[form]
  loop do
    pbMessage(_INTL("{1} wants to learn {2}{4}, but it already knows {3} moves.\1",
                pkmn_name, move_name, pkmn.numExtraMoves(form), pkmn.move_matched?(move_id) ? _INTL("<imp>(matched)</imp>") : ""), &block) unless bymachine
    choose = pbChooseMoveFromListEX(_INTL("Please choose a move that will be replaced with {1}.", move_name), moves)
    chose_move = choose[0]
    return false unless chose_move
    chose_move_index = choose[1]
    chose_move_name = choose[2]
    moves.delete_at(chose_move_index)
    pkmn.learn_extra_move(form, move_id, chose_move_index)
    pbMessage(_INTL("{1} forgot how to use {2}.\nAnd...", pkmn_name, chose_move_name), &block)
    pbMessage(_INTL("\\se[]{1} learned {2}!\\se[Pkmn move learnt]", pkmn_name, move_name), &block)
    return true
  end
end

class Pokemon
  def moves_for_dexyos
    @moves_for_dexyos ||= {}
  end

  def initializeExtraMoves
    [1, 2, 3].each do |form|
      next if moves_for_dexyos[form]
      moves_for_dexyos[form] = @moves.clone
    end
  end

  def numExtraMoves(form)
    moves_for_dexyos[form].length
  end

  def hasExtraMove?(form, move_id)
    move_data = GameData::Move.try_get(move_id)
    return false unless move_data
    return moves_for_dexyos[form].any? { |m| m.id == move_data.id }
  end

  def learn_extra_move(form, move_id, index = -1, ignoreMax = false)
    move_data = GameData::Move.try_get(move_id)
    return unless move_data
    moves = moves_for_dexyos[form]
    moves.insert(index, Pokemon::Move.new(move_data.id))
    moves.shift if numMoves > MAX_MOVES && !ignoreMax
  end
end

class PokeBattle_Battler
  def should_extra_moves?
    return false if boss?
    return false unless isSpecies?(:DEOXYS)
    return true
  end

  def resetExtraMoves
    return unless should_extra_moves?
    @moves_for_dexyos = Hash.new { |hash, key| hash[key] = [] }
    @pokemon.initializeExtraMoves
    @pokemon.moves_for_dexyos.each do |form_index, form_moves|
      form_moves.each_with_index do |m, i|
        @moves_for_dexyos[form_index][i] = PokeBattle_Move.from_pokemon_move(@battle, m)
      end
    end
  end
end