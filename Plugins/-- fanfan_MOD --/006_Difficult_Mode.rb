Events.onTrainerPartyLoad += proc { |_sender, e|
  trainer = e[0]
  next if !trainer || trainer.able_party.length >= 6
  pkmn = $Trainer.party_random_pkmn(true, true)
  pkmn.heal
  trainer.party << pkmn
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