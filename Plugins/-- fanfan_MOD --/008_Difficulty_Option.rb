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
  next unless trainer
  next if trainer.trainer_type == :ABSOL
  if trainer.party.length < 6 || TA.get(:copywhatever)
    pkmn = $Trainer.party_random_pkmn(false, true, false, TA.get(:copied_mon, []))
    trainer.party << pkmn if pkmn
  end
  trainer.party.shuffle! if trainer.trainer_type == :LEADER_Lambert
}

Events.onTrainerPartyLoad += proc { |_sender, e|
  trainer = e[0]
  next unless trainer
  higher_level = [$Trainer.party_highest_level, trainer.party_highest_level].max
  punish_level = TA.get(:kill_count, 0) - Settings::KILL_PUNNISHMENT
  trainer.party.each do |pkmn|
    if pkmn.level < higher_level
      pkmn.level = higher_level # level
      if pkmn.level < MAX_LEVEL_CAP && punish_level > 0
        punish_increment = [punish_level, MAX_LEVEL_CAP - pkmn.level].min
        pkmn.level += punish_increment
      end
      loop do
        species_data = pkmn.species_data # evo
        possible_evolutions = species_data.get_evolutions(true)
        break if possible_evolutions.empty?
        valid_evolutions = []
        possible_evolutions.each do |evo|
          evo_species = evo[0]
          evo_species_data = GameData::Species.get(evo_species)
          valid_evolutions << evo if evo_species_data.available_by?(pkmn.level)
        end
        break if valid_evolutions.empty?
        evo_species = valid_evolutions.sample[0]
        pkmn.species = evo_species
      end
    end
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