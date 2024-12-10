Events.onTrainerPartyLoad += proc { |_sender, e|
  next if !$Trainer.get_ta(:battle_loader)
  trainer = e[0]
  next if !trainer
  trainer.name = $Trainer.get_ta(:name)
  trainer.party.clear
  $Trainer.get_ta(:team).each { |pkmn| trainer.party << pkmn }
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  next if $Trainer.get_ta(:battle_loader)
  next if $Trainer.get_ta(:nocopymon)
  trainer = e[0]
  next if !trainer || trainer.able_party.length >= 6
  pkmn = $Trainer.party_random_pkmn(true, true)
  pkmn.heal
  trainer.party << pkmn
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  next if $Trainer.get_ta(:nocustomabil)
  trainer = e[0]
  next if !trainer
  trainer.party.each do |pkmn|
    next if pkmn.has_main_ability?
    #pkmn.ability = choose_random_ability
    possible_abil = choose_random_ability_from_player(pkmn)
    pkmn.ability = possible_abil if possible_abil
  end
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  trainer = e[0]
  next if !trainer
  target_level = $Trainer.party_highest_level
  trainer.each_able_pkmn do |pkmn|
    if pkmn.level < target_level
      pkmn.level = target_level
      pkmn.calc_stats
    end
  end
}

GameData::BattleEffect.register_effect(:Side, {
  :id => :FaintHealing,
  :real_name => "Faint Healing",
  :info_displayed => false,
  :type => :Hash,
  :eor_proc => proc do |battle, side, _teamName, value|
    value.each_key do |key|
      value[key] -= 1
      pkmn = battle.pbParty(side.index)[key]
      if pkmn
        if value[key] <= 0
          # Revive the pokemon
          pkmn.heal_HP
          pkmn.heal_status
          battle.pbDisplay(_INTL("{1} recovered all the way to full health!", pkmn.name))
          value[key] = nil
        elsif value[key] == 1
          battle.pbDisplay(_INTL("{1} is coming back to life!", pkmn.name))
        end
      end
    end
    value.compact!
  end,
})