ItemHandlers::UseOnPokemon.add(:ABILITYCAPSULE,proc { |item,pkmn,scene|
    unless teamEditingAllowed?
        showNoTeamEditingMessage
        return
    end
    abils = pkmn.getAbilityList
    abil1 = nil; abil2 = nil
    for i in abils
      abil1 = i[0] if i[1]==0
      abil2 = i[0] if i[1]==1
    end
    if abil1.nil? || abil2.nil? || pkmn.hasHiddenAbility? || pkmn.isSpecies?(:ZYGARDE)
      pbSceneDefaultDisplay(_INTL("It won't have any effect."),scene)
      next false
    end
    newabilindex = (pkmn.ability_index + 1) % 2
    newabil = GameData::Ability.get((newabilindex==0) ? abil1 : abil2)
    newabilname = newabil.name
	  msg = _INTL("Would you like to change {1}'s displaying ability to {2}?", pkmn.name, newabilname)
    if pbSceneDefaultConfirm(msg, scene)
      pkmn.ability_index = newabilindex
      pkmn.ability = newabil
      scene&.pbRefresh
	    msg = _INTL("{1}'s displaying ability changed to {2}!", pkmn.name, newabilname)
      pbSceneDefaultDisplay(msg, scene)
      pkmn.calc_stats
      next true
    end
    next false
})
  
ItemHandlers::UseOnPokemon.copy(:ABILITYCAPSULE,:VIRALHELIX)