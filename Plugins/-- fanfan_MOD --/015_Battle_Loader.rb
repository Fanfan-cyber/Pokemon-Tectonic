module BattleLoader
  BATTLE_LOADER_PATH = "Team Data"
  @@battle_loader = []

  def self.load_data
    Dir.mkdir(BATTLE_LOADER_PATH) rescue nil
    @@battle_loader.clear
    teams = Dir.glob("#{BATTLE_LOADER_PATH}/*.txt")
    teams.each do |info|
      encrypted_data = File.read(info)
      team_info = Marshal.restore(Zlib::Inflate.inflate(encrypted_data.unpack("m")[0]))
      @@battle_loader.push(team_info) # [rule, name, team, unique_id]
      @@battle_loader.sort_by! { |team_info| team_info[0] }
    end
  end

  def self.add_data(rule, name = "", team = nil)
    name = $Trainer.name if name.empty?
    unique_id = generate_unique_id
    new_team = [rule, name, team || $Trainer.party, unique_id]
    encrypted_data = [Zlib::Deflate.deflate(Marshal.dump(new_team))].pack("m")
    File.open("Team Data/#{rule}_#{name}_#{unique_id}.txt", "wb") do |file|
      file.write(encrypted_data)
    end
    load_data
  end

  def self.delete_data(unique_id)
    teams = Dir.glob("#{BATTLE_LOADER_PATH}/*.txt")
    teams.each do |info|
      next if !info.include?(unique_id)
      File.delete(info)
      break
    end
    load_data
  end

  def self.add_trainer_data(battle)
    return if $Trainer.get_ta(:battle_loader)
    return if !battle.trainerBattle?
    if pbConfirmMessage(_INTL("Do you want to add the opponent team into Battle Loader?"))
      load_data
      rules = ["1v1", "2v2", "1v2", "2v1"]
      ret = pbMessage(_INTL("Which battle rule do you want to use?"), rules, 0)
      if ret >= 0
        team = battle.pbParty(1)
        team.each { |pkmn| pkmn.heal }
        if pbConfirmMessage(_INTL("Would you like to give it a name?"))
          name = pbEnterText(_INTL("What name?"), 0, 30)
          if name.empty?
            add_data(rules[ret], battle.opponent.sample.name, team)
          else
            add_data(rules[ret], name, team)
          end
        else
          if battle.opponent.size > 1
            names = battle.opponent.map(&:name)
            choose = pbMessage(_INTL("Which default name do you want to use?"), names, -1)
            if choose >= 0
              add_data(rules[ret], battle.opponent[choose].name, team)
            else
              add_data(rules[ret], battle.opponent.sample.name, team)
            end
          else
            add_data(rules[ret], battle.opponent[0].name, team)
          end
        end
        pbMessage(_INTL("The team has been registered!"))
      end
    end
  end

  def self.open_battle_loader
    if !$Trainer.has_pokemon?
      pbMessage(_INTL("You can't start a battle now since you don't have any Pokémon!"))
      return
    end
    loop do
      choice = [_INTL("Battle"), _INTL("Export Team"), _INTL("Delete Team"), _INTL("Check Stats"), _INTL("Cancel")]
      choose = pbMessage(_INTL("What do you want to do?"), choice, -1)
      case choose
      when -1, 4 # Cancel
        break
      when 3 # Check Stats
        pbMessage(_INTL("Your Victory count is {1}!\nYour Lost count is {2}!", $Trainer.get_ta(:battle_win, 0), $Trainer.get_ta(:battle_lost, 0)))
      when 0 # Battle
        load_data
        if @@battle_loader.empty?
          pbMessage(_INTL("There aren't any teams in Battle Loader!"))
        else
          loop do
            battle_mode = [_INTL("Team"), _INTL("Random Team"), _INTL("Random Pokémon Team"), _INTL("Cancel")]
            mode_chosen = pbMessage(_INTL("What do you want to do?"), battle_mode, -1)
            case mode_chosen
            when -1, 3 # Cancel
              break
            when 0 # Team
              names = @@battle_loader.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
              index = pbMessage(_INTL("Which team do you want to challenge?"), names, -1)
              if index >= 0
                rule = @@battle_loader[index][0]
                team = @@battle_loader[index][2]
                rules = ["1v1", "2v2", "1v2", "2v1"]
                rules.reject! {|other_rule| other_rule == rule }
                ret = pbMessage(_INTL("Do you want to use other battle rules?"), rules, -1)
                if ret >= 0
                  start_battle(rules[ret], team)
                else
                  start_battle(rule, team)
                end
              end
            when 1 # Random Team
              random_chosen = @@battle_loader.sample
              team = random_chosen[2]
              rules = ["1v1", "2v2", "1v2", "2v1"]
              ret = pbMessage(_INTL("Which battle rule do you want to use?"), rules, -1)
              if ret >= 0
                start_battle(rules[ret], team)
              else
                start_battle(rules[0], team)
              end
            when 2 # Random Pokémon Team
              team = get_random_pkmn_team
              rules = ["1v1", "2v2", "1v2", "2v1"]
              ret = pbMessage(_INTL("Which battle rule do you want to use?"), rules, -1)
              if ret >= 0
                start_battle(rules[ret], team)
              else
                start_battle(rules[0], team)
              end
            end
          end
        end
      when 1 # Export Team
        load_data
        rules = ["1v1", "2v2", "1v2", "2v1"]
        ret = pbMessage(_INTL("Which battle rule do you want?"), rules, -1)
        if ret >= 0
          if pbConfirmMessage(_INTL("Would you like to give it a name?"))
            name = pbEnterText(_INTL("What name?"), 0, 30)
            add_data(rules[ret], name)
          else
            add_data(rules[ret])
          end
          pbMessage(_INTL("Your team has been exported!"))
        end
      when 2 # Delete Team
        load_data
        if @@battle_loader.empty?
          pbMessage(_INTL("There isn't any teams in Battle Loader!"))
        else
          names = @@battle_loader.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
          index = pbMessage(_INTL("Which team do you want to delete?"), names, -1)
          if index >= 0 && pbConfirmMessage(_INTL("Do you really want to delete it?"))
            unique_id = @@battle_loader[index][3]
            delete_data(unique_id)
            pbMessage(_INTL("Team {1} has been deleted!", unique_id))
          end
        end
      end
    end
  end

  def self.get_all_teams
    load_data
    @@battle_loader.map { |team_data| team_data[2] }
  end

  def self.get_all_pkmn
    get_all_teams.flatten
  end

  def self.get_random_pkmn_team
    pkmn_data_base = PokemonDataBase.get_pkmn_data_base.clone
    pkmn_data_base.concat(get_all_pkmn).sample(6)
  end

  def self.start_battle(rule, team)
    setBattleRule(rule)
    $Trainer.set_ta(:battle_loader, true)
    $Trainer.set_ta(:team, team)
    trainer = GameData::Trainer.values.sample
    trainer_type = trainer.trainer_type
    trainer_type_data = GameData::TrainerType.get(trainer_type)
    if trainer_type_data.male?
      $Trainer.set_ta(:name, BOY_NAMES.sample)
    elsif trainer_type_data.female?
      $Trainer.set_ta(:name, GIRL_NAMES.sample)
    else
      $Trainer.set_ta(:name, _INTL("Unknown"))
    end
    #pbTrainerBattle(:LEADER_Lambert, "Lambert", nil, false, 0, true)
    results = pbTrainerBattle(trainer_type, trainer.real_name, nil, false, 0, true)
    results ? $Trainer.increase_ta(:battle_win) : $Trainer.increase_ta(:battle_lost)
    $Trainer.set_ta(:battle_loader, false)
  end
end

module PokemonDataBase
  PKMN_DATA_AMOUNT  = 1000
  LOWEST_PKMN_BST   = 450
  LOWEST_MOVE_POWER = 60

  @@pkmn_data = []

  def self.create_pkmn
    species_list = GameData::Species.keys.shuffle
    p species_list.size
    species_list.each do |species|
      species_data = GameData::Species.get(species)
      next if species_data.base_stat_total < LOWEST_PKMN_BST
      pkmn = Pokemon.new(species_data.id, 1)

      pkmn.forget_all_moves
      legal_moves = species_data.learnable_moves.shuffle
      4.times do
        legal_moves.each do |move|
          move_data = GameData::Move.get(move)
          next if move_data.base_damage < LOWEST_MOVE_POWER
          pkmn.learn_move(move_data)
          break
        end
      end
      pkmn.calc_stats
      @@pkmn_data << pkmn
      return pkmn
    end
  end

  def self.create_mass
    PKMN_DATA_AMOUNT.times { create_pkmn } if @@pkmn_data.empty?
  end

  def self.get_pkmn_data_base
    @@pkmn_data
  end
end

PokemonDataBase.create_mass