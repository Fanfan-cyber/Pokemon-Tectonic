class Trainer
  attr_reader :is_player

  def is_player?
    is_player
  end

  def has_pokemon?
    @party.length >= 1
  end

  def each_pkmn
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && !pkmn.egg? }
  end

  def each_able_pkmn
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && !pkmn.egg? && !pkmn.fainted? }
  end

  def each_fainted_pkmn
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && !pkmn.egg? && pkmn.fainted? }
  end

  def has_fainted_pkmn?
    pokemon_party.any?(&:fainted?)
  end

  def each_egg
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && pkmn.egg? }
  end

  def party_highest_level(able = true)
    able ? able_party.map(&:level).max : pokemon_party.map(&:level).max
  end

  def party_lowest_level(able = true)
    able ? able_party.map(&:level).min : pokemon_party.map(&:level).min
  end

  def party_random_pkmn(able = true, pkmn_clone = false)
    pkmn = able ? able_party.sample : pokemon_party.sample
    pkmn_clone ? pkmn.clone_pkmn : pkmn
  end

  def party_items
    @party.map(&:items).flatten.compact
  end

  def party_dup_item?
    party_items.dup?
  end

  def party_item_already?(item)
    party_items.include?(item)
  end

  def party_statuses
    @party.map(&:status).delete_if { |status| status == :NONE }
  end

  def party_dup_status?
    party_statuses.dup?
  end

  def party_status_already?(status)
    party_statuses.include?(status)
  end

  def pbGetPartyIndex(species, form = 0)
    each_pkmn { |pkmn, index| return index if pkmn.isSpecies?(species) && pkmn.form == form }
    return nil
  end

  def pbSwapPartyPosition(species, new_index = 0, form = 0)
    old_index = pbGetPartyIndex(species, form)
    return if !old_index || old_index == new_index
    @party.swap!(old_index, new_index)
  end

  def remove_pokemon_by_index(species, form = 0)
    index = pbGetPartyIndex(species, form)
    return if !index
    remove_pokemon_at_index(index)
  end

  def remove_pokemon_by_selection(show_message = true)
    selection_data = pbChoosePokemonEX
    pkmn = selection_data[0]
    index = selection_data[1]
    pkmn_name = selection_data[2]
    return if !pkmn
    ret = remove_pokemon_at_index(index)
    return if !show_message
    if ret
      pbMessage(_INTL("{1} has been removed!", pkmn_name))
    else
      pbMessage(_INTL("{1} can't be removed!", pkmn_name))
    end
  end
end