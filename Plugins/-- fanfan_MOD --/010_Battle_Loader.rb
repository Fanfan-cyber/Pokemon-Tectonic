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
    unique_id = generate_unique_id
    new_team = [rule, name.empty? ? $Trainer.name : name, team || $Trainer.party, unique_id]
    encrypted_data = [Zlib::Deflate.deflate(Marshal.dump(new_team))].pack("m")
    File.open("Team Data/#{rule}_#{name}_#{unique_id}.txt", "wb") do |file|
      file.write(encrypted_data)
    end
    self.load_data
  end

  def self.delete_data(unique_id)
    teams = Dir.glob("#{BATTLE_LOADER_PATH}/*.txt")
    file = nil
    teams.each do |info|
      file = info if info.include?(unique_id)
      break
    end
    File.delete(file) if file
    self.load_data
  end

  def self.add_trainer_data(battle)
    if pbConfirmMessage(_INTL("Do you want to add the opponent team into Battle Loader?"))
      self.load_data
      rules = [_INTL("1v1"), _INTL("2v2"), _INTL("1v2"), _INTL("2v1")]
      ret = pbMessage(_INTL("Which battle rule do you want?"), rules, 0)
      if ret >= 0
        team = battle.pbParty(1)
        team.each { |pkmn| pkmn.heal }
        if pbConfirmMessage(_INTL("Would you like to give it a name?"))
          name = pbEnterText(_INTL("What name?"), 0, 30)
          if name.empty?
            self.add_data(rules[ret], battle.opponent.sample.name, team)
          else
            self.add_data(rules[ret], name, team)
          end
        else
          if battle.opponent.size > 1
            names = battle.opponent.map(&:name)
            choose = pbMessage(_INTL("Which default name you want to use?"), names, -1)
            if choose >= 0
              self.add_data(rules[ret], battle.opponent[choose].name, team)
            else
              self.add_data(rules[ret], battle.opponent.sample.name, team)
            end
          else
            self.add_data(rules[ret], battle.opponent[0].name, team)
          end
        end
        pbMessage(_INTL("The team has been registered!"))
      end
    end
  end

  def self.open_battle_loader
    choice = [_INTL("Battle"), _INTL("Export Team"), _INTL("Delete Team"), _INTL("Cancel")]
    choose = pbMessage(_INTL("What do you want to do?"), choice, -1)
    case choose
    when 0
      self.load_data
      if @@battle_loader.empty?
        pbMessage(_INTL("There isn't any teams in Battle Loader!"))
      else
        names = @@battle_loader.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
        index = pbMessage(_INTL("Which team do you want to challenge?"), names, -1)
        if index >= 0
          rule = @@battle_loader[index][0]
          team = @@battle_loader[index][2]
          rules = [_INTL("1v1"), _INTL("2v2"), _INTL("1v2"), _INTL("2v1")]
          rules.reject! {|other_rule| other_rule == rule }
          ret = pbMessage(_INTL("Do you want to use other battle rules?"), rules, -1)
          if ret >= 0
            self.start_battle(rules[ret], team)
          else
            self.start_battle(rule, team)
          end
        end
      end
    when 1
      self.load_data
      rules = [_INTL("1v1"), _INTL("2v2"), _INTL("1v2"), _INTL("2v1")]
      ret = pbMessage(_INTL("Which battle rule do you want?"), rules, -1)
      if ret >= 0
        if pbConfirmMessage(_INTL("Would you like to give it a name?"))
          name = pbEnterText(_INTL("What name?"), 0, 30)
          self.add_data(rules[ret], name)
        else
          self.add_data(rules[ret])
        end
        pbMessage(_INTL("Your team exported!"))
      end
    when 2
      self.load_data
      if @@battle_loader.empty?
        pbMessage(_INTL("There isn't any teams in Battle Loader!"))
      else
        names = @@battle_loader.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
        index = pbMessage(_INTL("Which team do you want to delete?"), names, -1)
        if index >= 0 && pbConfirmMessage(_INTL("Do you really want to delete it?"))
          unique_id = @@battle_loader[index][3]
          self.delete_data(unique_id)
          pbMessage(_INTL("This team has been deleted!"))
        end
      end
    end
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
    pbTrainerBattle(trainer_type, trainer.name, nil, false, trainer.version, true)
    $Trainer.set_ta(:battle_loader, false)
  end
end