Events.onTrainerPartyLoad += proc { |_sender, e|
  next if !$Trainer.get_ta(:battle_loader)
  trainer = e[0]
  next if !trainer
  trainer.name = $Trainer.get_ta(:name)
  trainer.party.clear
  $Trainer.get_ta(:team).each { |pkmn| trainer.party << pkmn.clone_pkmn }
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  next if $Trainer.get_ta(:battle_loader)
  next if $Trainer.get_ta(:nocopymon)
  trainer = e[0]
  next if !trainer || trainer.able_party.length >= 6
  pkmn = $Trainer.party_random_pkmn(true, true)
  trainer.party << pkmn
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  next if !$Trainer.get_ta(:customabil)
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
  trainer.party.each do |pkmn|
    if pkmn.level < target_level
      pkmn.level = target_level
      pkmn.calc_stats
    end
    pkmn.level += $Trainer.get_ta(:kill_count, 0)
    pkmn.heal
  end
}