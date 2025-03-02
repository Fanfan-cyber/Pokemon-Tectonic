Events.onTrainerPartyLoad += proc { |_sender, e|
  next unless TA.get(:battle_loader)
  trainer = e[0]
  next unless trainer
  trainer.name = TA.get(:name)
  trainer.party.clear
  TA.get(:team).each { |pkmn| trainer.party << pkmn.clone_pkmn }
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  next if TA.get(:battle_loader)
  next if TA.get(:nocopymon)
  trainer = e[0]
  next if !trainer || trainer.able_party.length >= 6
  pkmn = $Trainer.party_random_pkmn(true, true)
  if trainer.trainer_type == :LEADER_Lambert && rand(100) < 50
    trainer.party.unshift(pkmn)
  else
    trainer.party << pkmn
  end
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  trainer = e[0]
  next unless trainer
  player_level = $Trainer.party_highest_level
  trainer_level = trainer.party_highest_level
  punish_level = TA.get(:kill_count, 0)
  trainer.party.each do |pkmn|
    pkmn.level = player_level if pkmn.level < player_level
    pkmn.level = trainer_level if pkmn.level < trainer_level
    pkmn.level += punish_level - Settings::KILL_PUNNISHMENT if punish_level > Settings::KILL_PUNNISHMENT
    pkmn.calc_stats
    pkmn.heal
  end
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  trainer = e[0]
  next unless trainer
  trainer.party.each do |pkmn|
    pkmn.items.concat(Settings::DEFAULT_ITEMS) unless pkmn.hasItem?
  end
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  next unless TA.get(:customabil)
  trainer = e[0]
  next unless trainer
  trainer.party.each do |pkmn|
    next if pkmn.has_main_ability?
    #pkmn.ability = TA.choose_random_ability(pkmn)
    possible_abil = TA.choose_random_ability_from_player(pkmn)
    pkmn.ability = possible_abil if possible_abil
  end
}