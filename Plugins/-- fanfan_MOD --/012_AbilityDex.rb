module AbilityDex
  def self.open_abilitydex
    listIndex = 0
    loop do
      id, listIndex = pbListScreenGuide(_INTL("AbilityDex"), BattleGuideLister.new(abilityDexMainHash, listIndex))
      break if id.nil?
      sectionLabel = abilityDexMainDirectory.keys[listIndex]
      directoryEntry = abilityDexMainDirectory.values[listIndex]
      guideListHash = send directoryEntry[1]
      pbListScreenGuide(+ sectionLabel, BattleGuideLister.new(guideListHash), false)
	  end
  end

  def self.abilityDexMainHash
    mainHash = {}
    abilityDexMainDirectory.each do |key, value|
      mainHash[key] = value[0]
    end
    mainHash
  end

  def self.abilityDexMainDirectory
    {_INTL("Ability Canon")    => [_INTL("Abilities that GF made."), :abilityCanon],
     _INTL("Ability New")      => [_INTL("Abilities that is new in Pokémon Tectonic."), :abilityNew],
     _INTL("Ability Cut")      => [_INTL("Abilities that have been cut."), :abilityCut],
     _INTL("Ability Primeval") => [_INTL("Abilities that Avatars possess only."), :abilityPrimeval], }
  end

  def self.abilityCanon
    abilis_pool = {}
    GameData::Ability.each do |abil|
      next if abil.cut || abil.tectonic_new
      abilis_pool[abil.name] = abil.description
    end
    abilis_pool
  end

  def self.abilityNew
    abilis_pool = {}
    GameData::Ability.each do |abil|
      next if !abil.tectonic_new || abil.primeval || abil.cut
      abilis_pool[abil.name] = abil.description
    end
    abilis_pool
  end

  def self.abilityCut
    abilis_pool = {}
    GameData::Ability.each do |abil|
      next if !abil.cut
      abilis_pool[abil.name] = abil.description
    end
    abilis_pool
  end

  def self.abilityPrimeval
    abilis_pool = {}
    GameData::Ability.each do |abil|
      next if !abil.primeval
      abilis_pool[abil.name] = abil.description
    end
    abilis_pool
  end
end