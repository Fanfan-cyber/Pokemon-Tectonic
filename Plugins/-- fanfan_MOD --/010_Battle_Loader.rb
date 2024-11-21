module BattleLoader
  BATTLE_LOADER_PATH = "Team Data"
  BATTLE_LOADER_FILE = Dir.glob("Team Data/team_data_*.txt")
  @@battle_loader = {}

  def self.load_data
    Dir.mkdir(BATTLE_LOADER_PATH) rescue nil
    BATTLE_LOADER_FILE.each do |team|
      encrypted_data = File.read(team)
      battle_info = Marshal.restore(Zlib::Inflate.inflate(encrypted_data.unpack("m")[0]))
      @@battle_loader[team[20...-4]] = [battle_info[0], battle_info[1]]
    end
  end

  def self.save_data(rule)
    @@battle_loader["#{$Trainer.name}_#{generate_unique_id}"] = [$Trainer.party, rule]
    @@battle_loader.each do |trainer, team|
      encrypted_data = [Zlib::Deflate.deflate(Marshal.dump(team))].pack("m")
      File.open("Team Data/team_data_#{trainer}.txt", "wb") do |file|
        file.write(encrypted_data)
      end
    end
  end

  def self.open_battle_loader
    choose = pbMessage(_INTL("What do you want to do?"), [_INTL("Battle"), _INTL("Export Team"), _INTL("Cancel")], -1)
    case choose
    when 0
      if !@@battle_loader.empty?
        teams_names = []
        teams = []
        rules = []
        names = []
        @@battle_loader.each do |trainer, battle_info|
          teams_names.push("#{trainer.split("_")[0]} #{battle_info[1]}")
          teams.push(battle_info[0])
          rules.push(battle_info[1])
          names.push("#{trainer.split("_")[0]}")
        end
        index = pbMessage(_INTL("Which team do you want to challenge?"), teams_names, -1)
        if index >= 0
          team = teams[index]
          rule = rules[index]
          name = names[index]
          self.start_battle(name, team, rule)
        end
      end
    when 1
      rules = [_INTL("1v1"), _INTL("2v2"), _INTL("1v2"), _INTL("2v1")]
      ret = pbMessage(_INTL("Which battle rule do you want?"), rules, -1)
      if ret >= 0
        self.save_data(rules[ret])
        pbMessage(_INTL("Your team exported!"))
      end
    end
  end

  def self.start_battle(name, team, rule)
    setBattleRule(rule)
    $team = team
    $name = name
    pbTrainerBattle(:LASS2, "Sienna", nil, false, 0, true)
  end
end

BattleLoader.load_data