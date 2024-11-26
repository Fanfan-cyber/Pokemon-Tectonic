class PokeBattle_Battle
  def each_party1_pkmn
    @party1.each { |pkmn| yield pkmn if !pkmn.egg? }
  end

  def each_party1_able_pkmn
    @party1.each { |pkmn| yield pkmn if !pkmn.egg? && !pkmn.fainted? }
  end

  def each_party1_fainted_pkmn
    @party1.each { |pkmn| yield pkmn if !pkmn.egg? && pkmn.fainted? }
  end

  def party1_able_pkmn
    able_pkmn = []
    each_party1_able_pkmn { |pkmn| able_pkmn.push(pkmn) }
    able_pkmn
  end

  def party1_fainted_pkmn
    fainted_pkmn = []
    each_party1_fainted_pkmn { |pkmn| fainted_pkmn.push(pkmn) }
    fainted_pkmn
  end

  def each_party2_pkmn
    @party2.each { |pkmn| yield pkmn if !pkmn.egg? }
  end

  def each_party2_able_pkmn
    @party2.each { |pkmn| yield pkmn if !pkmn.egg? && !pkmn.fainted? }
  end

  def each_party2_fainted_pkmn
    @party2.each { |pkmn| yield pkmn if !pkmn.egg? && pkmn.fainted? }
  end

  def party2_able_pkmn
    able_pkmn = []
    each_party2_able_pkmn { |pkmn| able_pkmn.push(pkmn) }
    able_pkmn
  end

  def party2_fainted_pkmn
    fainted_pkmn = []
    each_party2_fainted_pkmn { |pkmn| fainted_pkmn.push(pkmn) }
    fainted_pkmn
  end

  def both_party_pkmn
    @party1 + @party2
  end

  def each_both_party_pkmn
    both_party_pkmn.each { |pkmn| yield pkmn if !pkmn.egg? }
  end

  def each_both_party_able_pkmn
    both_party_pkmn.each { |pkmn| yield pkmn if !pkmn.egg? && !pkmn.fainted? }
  end

  def each_both_party_fainted_pkmn
    both_party_pkmn.each { |pkmn| yield pkmn if !pkmn.egg? && pkmn.fainted? }
  end

  def both_party_able_pkmn
    able_pkmn = []
    each_both_party_able_pkmn { |pkmn| able_pkmn.push(pkmn) }
    able_pkmn
  end

  def both_party_fainted_pkmn
    fainted_pkmn = []
    each_both_party_fainted_pkmn { |pkmn| fainted_pkmn.push(pkmn) }
    fainted_pkmn
  end

  def all_battlers
    @battlers.compact
  end

  def party1_battlers_ids
    party1_ids = []
    eachSameSideBattler { |b| party1_ids.push(b.unique_id) }
    party1_ids
  end

  def party2_battlers_ids
    party2_ids = []
    eachOtherSideBattler { |b| party2_ids.push(b.unique_id) }
    party2_ids
  end

  def all_battlers_ids
    all_battlers.map { |b| b.unique_id }
  end

  def each_party1_back_pkmn
    each_party1_pkmn { |pkmn| yield pkmn if !party1_battlers_ids.has?(pkmn.unique_id) }
  end

  def each_party1_back_able_pkmn
    each_party1_able_pkmn { |pkmn| yield pkmn if !party1_battlers_ids.has?(pkmn.unique_id) }
  end

  def party1_back_pkmn
    party1_pkmn = []
    each_party1_back_pkmn { |pkmn| party1_pkmn.push(pkmn) }
    party1_pkmn
  end

  def party1_back_able_pkmn
    party1_able_pkmn = []
    each_party1_back_able_pkmn { |pkmn| party1_able_pkmn.push(pkmn) }
    party1_able_pkmn
  end

  def each_party2_back_pkmn
    each_party2_pkmn { |pkmn| yield pkmn if !party2_battlers_ids.has?(pkmn.unique_id) }
  end

  def each_party2_back_able_pkmn
    each_party2_able_pkmn { |pkmn| yield pkmn if !party2_battlers_ids.has?(pkmn.unique_id) }
  end

  def party2_back_pkmn
    party2_pkmn = []
    each_party2_pkmn { |pkmn| party2_pkmn.push(pkmn) }
    party2_pkmn
  end

  def party2_back_able_pkmn
    party2_able_pkmn = []
    each_party2_back_able_pkmn { |pkmn| party2_able_pkmn.push(pkmn) }
    party2_able_pkmn
  end

  def each_both_party_back_pkmn
    each_both_party_pkmn { |pkmn| yield pkmn if !all_battlers_ids.has?(pkmn.unique_id) }
  end

  def each_both_party_back_able_pkmn
    each_both_party_able_pkmn { |pkmn| yield pkmn if !all_battlers_ids.has?(pkmn.unique_id) }
  end

  def both_party_back_pkmn
    party_back_pkmn = []
    each_both_party_back_pkmn { |pkmn| party_back_pkmn.push(pkmn) }
    party_back_pkmn
  end

  def both_party_back_able_pkmn
    party_back_able_pkmn = []
    each_both_party_back_able_pkmn { |pkmn| party_back_able_pkmn.push(pkmn) }
    party_back_able_pkmn
  end

  def all_battlers_types
    current_types = []
    eachBattler { |b| current_types.concat(b.pbTypes(true)) }
    current_types
  end

  def party1_pkmn_types
    @party1.map(&:types).flatten
  end

  def party1_able_pkmn_types
    party1_types = []
    each_party1_able_pkmn { |pkmn| party1_types.concat(pkmn.types) }
    party1_types
  end

  def party1_back_pkmn_types
    party1_types = []
    each_party1_back_pkmn { |pkmn| party1_types.concat(pkmn.types) }
    party1_types
  end

  def party1_back_able_pkmn_types
    party1_types = []
    each_party1_back_able_pkmn { |pkmn| party1_types.concat(pkmn.types) }
    party1_types
  end

  def party2_pkmn_types
    @party2.map(&:types).flatten
  end

  def party2_able_pkmn_types
    party2_types = []
    each_party2_able_pkmn { |pkmn| party2_types.concat(pkmn.types) }
    party2_types
  end

  def party2_back_pkmn_types
    party2_types = []
    each_party2_back_pkmn { |pkmn| party2_types.concat(pkmn.types) }
    party2_types
  end

  def party2_back_able_pkmn_types
    party2_types = []
    each_party2_back_able_pkmn { |pkmn| party2_types.concat(pkmn.types) }
    party2_types
  end

  def both_party_pkmn_types
    both_party_pkmn.map(&:types).flatten
  end

  def both_party_able_pkmn_types
    all_able_types = []
    each_both_party_able_pkmn { |pkmn| all_able_types.concat(pkmn.types) }
    all_able_types
  end

  def both_party_back_pkmn_types
    both_party_types = []
    each_both_party_back_pkmn { |pkmn| both_party_types.concat(pkmn.types) }
    both_party_types
  end

  def both_party_back_able_pkmn_types
    both_party_types = []
    each_both_party_back_able_pkmn { |pkmn| both_party_types.concat(pkmn.types) }
    both_party_types
  end

  def all_current_types
    current_types = []
    current_types.concat(all_battlers_types, both_party_back_able_pkmn_types)
    current_types
  end

  def most_current_type
    all_current_types.most_element
  end

  def least_current_type
    all_current_types.least_element
  end
end