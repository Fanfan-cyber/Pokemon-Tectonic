module AbilityDex
  @@abilis_canon    = nil
  @@abilis_new      = nil
  @@abilis_primeval = nil
  @@abilis_cut      = nil
  @@abilis_fanfan   = nil

  def self.open_abilitydex
    listIndex = 0
    loop do
      id, listIndex = pbListScreenGuide(_INTL("AbilityDex (Search: Z)"), BattleGuideLister.new(abilityDexMainHash, listIndex))
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
     _INTL("Ability Fanfan")      => [_INTL("Abilities that made by Fanfan."), :abilityFanfan],
     _INTL("Ability Primeval") => [_INTL("Abilities that Avatars possess only."), :abilityPrimeval],
     _INTL("Ability Cut")      => [_INTL("Abilities that have been cut."), :abilityCut], }
  end

  def self.abilityCanon
    return @@abilis_canon if @@abilis_canon
    @@abilis_canon = {}
    count = 0
    GameData::Ability.each do |abil|
      next if abil.cut || abil.tectonic_new
      count += 1
      @@abilis_canon["#{count} #{abil.name}"] = "#{abil.description}\n#{abil.details}"
    end
    @@abilis_canon
  end

  def self.abilityNew
    return @@abilis_new if @@abilis_new
    @@abilis_new = {}
    count = 0
    GameData::Ability.each do |abil|
      next if !abil.tectonic_new || abil.primeval || abil.cut
      next if abil.is_test?
      count += 1
      @@abilis_new["#{count} #{abil.name}"] = "#{abil.description}\n#{abil.details}"
    end
    @@abilis_new
  end

  def self.abilityFanfan
    return @@abilis_fanfan if @@abilis_fanfan
    @@abilis_fanfan = {}
    count = 0
    GameData::Ability.each do |abil|
      next if !abil.file_path
      next if abil.is_test?
      count += 1
      @@abilis_fanfan["#{count} #{abil.name}"] = "#{abil.description}\n#{abil.details}"
    end
    @@abilis_fanfan
  end

  def self.abilityPrimeval
    return @@abilis_primeval if @@abilis_primeval
    @@abilis_primeval = {}
    count = 0
    GameData::Ability.each do |abil|
      next if !abil.primeval
      count += 1
      @@abilis_primeval["#{count} #{abil.name}"] = "#{abil.description}\n#{abil.details}"
    end
    @@abilis_primeval
  end

  def self.abilityCut
    return @@abilis_cut if @@abilis_cut
    @@abilis_cut = {}
    count = 0
    GameData::Ability.each do |abil|
      next if !abil.cut
      count += 1
      @@abilis_cut["#{count} #{abil.name}"] = "#{abil.description}\n#{abil.details}"
    end
    @@abilis_cut
  end
end