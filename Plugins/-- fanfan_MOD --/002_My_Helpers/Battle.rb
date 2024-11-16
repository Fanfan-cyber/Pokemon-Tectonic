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

  def both_party
    @party1 + @party2
  end

  def each_both_party_pkmn
    both_party.each { |pkmn| yield pkmn if !pkmn.egg? }
  end

  def each_both_party_able_pkmn
    both_party.each { |pkmn| yield pkmn if !pkmn.egg? && !pkmn.fainted? }
  end

  def each_both_party_fainted_pkmn
    both_party.each { |pkmn| yield pkmn if !pkmn.egg? && pkmn.fainted? }
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

  def party1_pkmn_types
    @party1.map(&:types).flatten
  end

  def party1_able_pkmn_types
    party1_types = []
    each_party1_able_pkmn { |pkmn| party1_types.add(pkmn.types) }
    party1_types
  end

  def party2_pkmn_types
    @party2.map(&:types).flatten
  end

  def party2_able_pkmn_types
    party2_types = []
    each_party2_able_pkmn { |pkmn| party2_types.add(pkmn.types) }
    party2_types
  end

  def both_party_pkmn_types
    both_party.map(&:types).flatten
  end

  def both_party_able_pkmn_types
    all_able_types = []
    each_both_party_able_pkmn { |pkmn| all_able_types.add(pkmn.types) }
    all_able_types
  end

  def all_battlers
    @battlers.compact
  end

  def all_battlers_types
    current_types = []
    eachBattler { |b| current_types.add(b.pbTypes) }
    current_types = []
  end

  def party1_battlers_ids
    party1_ids = []
    eachSameSideBattler { |b| party1_ids.push(b.pokemon.personalID) }
    party1_ids
  end

  def party2_battlers_ids
    party2_ids = []
    eachOtherSideBattler { |b| party2_ids.push(b.pokemon.personalID) }
    party2_ids
  end

  def all_battlers_ids
    all_battlers.map { |b| b.pokemon.personalID }
  end

  def each_party1_back_pkmn
    each_party1_pkmn { |pkmn| yield pkmn if !party1_battlers_ids.has?(pkmn.personalID) }
  end

  def each_party1_back_able_pkmn
    each_party1_able_pkmn { |pkmn| yield pkmn if !party1_battlers_ids.has?(pkmn.personalID) }
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
    each_party2_pkmn { |pkmn| yield pkmn if !party2_battlers_ids.has?(pkmn.personalID) }
  end

  def each_party2_back_able_pkmn
    each_party2_able_pkmn { |pkmn| yield pkmn if !party2_battlers_ids.has?(pkmn.personalID) }
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

  def each_back_pkmn
  end

  def all_back_pkmn
    back_pkmn = []
    each_both_party_pkmn do |pkmn|
      back_pkmn.add(pkmn) if !all_battlers_ids.has?(pkmn.personalID)
    end
    back_pkmn
  end

  def all_back_able_pkmn
    back_pkmn = []
    each_both_party_able_pkmn do |pkmn|
      back_pkmn.add(pkmn) if !all_battlers_ids.has?(pkmn.personalID)
    end
    back_pkmn
  end

  def each_back_pkmn
    all_back_pkmn.each { |pkmn| yield pkmn }
  end

  def each_back_able_pkmn
    all_back_able_pkmn.each { |pkmn| yield pkmn }
  end

  def all_current_types
    current_types = []
    current_types.add(all_battlers_types)
    each_both_party_able_pkmn do |pkmn|
      current_types.add(pkmn.types) if !all_battlers_ids.has?(pkmn.personalID)
    end
    current_types
  end

  def most_type
    all_types.most_element
  end

  def least_type
    all_types.least_element
  end
end