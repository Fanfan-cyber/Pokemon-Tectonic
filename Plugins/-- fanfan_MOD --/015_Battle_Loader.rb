module BattleLoader
  BATTLE_LOADER_PATH = "Team Data"
  @@battle_loader    = []
  @@coded_teams      = []
  @@refresh          = true

  def self.load_data
    return unless @@refresh
    Dir.mkdir(BATTLE_LOADER_PATH) rescue nil
    @@battle_loader.clear
    teams = Dir.glob("#{BATTLE_LOADER_PATH}/*.txt")
    teams.each do |info|
      encrypted_data = File.read(info)
      team_info = process_encrypted_data(encrypted_data)
      team_info[4] = [] unless team_info[4]
      @@battle_loader.push(team_info) # [rule, name, team, unique_id, curse]
    end
    @@battle_loader.sort_by!(&:first)
    if @@coded_teams.empty?
      TEAM_DATA.each do |team_id, encrypted_data|
        team_info = process_encrypted_data(encrypted_data)
        team_info[4] = [] unless team_info[4]
        team_info[5] = team_id[1] # [rule, name, team, unique_id, curse, deletability]
        team_info[6] = :FormerChampion # [rule, name, team, unique_id, curse, deletability , tag]
        @@coded_teams.push(team_info)
      end
    end
    @@battle_loader.concat(@@coded_teams)
    check_legality
    @@refresh = false
    PokemonDataBase.create_mass
  end

  def self.process_encrypted_data(encrypted_str)
    Marshal.restore(Zlib::Inflate.inflate(encrypted_str.unpack("m")[0]))
  end

  def self.add_data(rule, name = "", team = nil, curse = [])
    name = $Trainer.name if name.empty?
    unique_id = generate_unique_id
    new_team = [rule, name, team || $Trainer.party, unique_id, curse]
    encrypted_data = [Zlib::Deflate.deflate(Marshal.dump(new_team))].pack("m")
    File.open("#{BATTLE_LOADER_PATH}/#{rule}_#{name}_#{unique_id}.txt", "wb") do |file|
      file.write(encrypted_data)
    end
    @@refresh = true
    load_data
  end

  def self.delete_data(unique_id, show_message = true)
    teams = Dir.glob("#{BATTLE_LOADER_PATH}/*.txt")
    deleted = false
    teams.each do |info|
      next unless info.include?(unique_id)
      File.delete(info)
      deleted = true
      break
    end
    if show_message
      if deleted
        pbMessage(_INTL("Team {1} has been deleted!", unique_id))
      else
        pbMessage(_INTL("The team can't be deleted!"))
      end
    end
    @@refresh = true
    load_data
  end

  def self.add_trainer_data(battle)
    return if TA.get(:battle_loader)
    return unless battle.trainerBattle?
    length = battle.opponent.length
    return if length >= 3
    if pbConfirmMessageSerious(_INTL("Do you want to add the opposing team to the Battle Loader?"))
      load_data
      curse = battle.curses
      rules = ["1v1", "2v2", "1v2", "2v1"]
      ret = pbMessage(_INTL("Which battle rule do you want to use?"), rules, 0)
      if ret >= 0
        if length == 1
          team = battle.pbParty(1)
        else
          team = []
          battle.opponent.each_with_index do |trainer, index|
            if index == 0
              team.concat(trainer.party)
            else
              team.insert(1, trainer.party[0]) 
              team.concat(trainer.party.drop_first)
            end
          end
        end
        team.each { |pkmn| pkmn.heal }
        if pbConfirmMessage(_INTL("Would you like to give it a name?"))
          name = pbEnterText(_INTL("What name?"), 0, 30)
          if name.empty?
            add_data(rules[ret], battle.opponent.sample.name, team, curse)
          else
            add_data(rules[ret], name, team, curse)
          end
        else
          if length > 1
            names = battle.opponent.map(&:name)
            choose = pbMessage(_INTL("Which default name do you want to use?"), names, -1)
            if choose >= 0
              add_data(rules[ret], battle.opponent[choose].name, team, curse)
            else
              add_data(rules[ret], battle.opponent.sample.name, team, curse)
            end
          else
            add_data(rules[ret], battle.opponent[0].name, team, curse)
          end
        end
        pbMessage(_INTL("The team has been registered!"))
      end
    end
  end

  def self.open_battle_loader
    unless $Trainer.has_pokemon?
      pbMessage(_INTL("You can't start a battle now because you don't have any Pokémon!"))
      return
    end
    loop do
      choice = [_INTL("Battle"), _INTL("Export Team"), _INTL("Delete Team"), _INTL("Check Stats"), _INTL("Cancel")]
      choose = pbMessage(_INTL("What do you want to do?"), choice, -1)
      case choose
      when -1, 4 # Cancel
        break
      when 3 # Check Stats
        pbMessage(_INTL("Your Victory count is {1}!\nYour Defeat count is {2}!", TA.get(:battle_victory, 0), TA.get(:battle_defeat, 0)))
      when 0 # Battle
        load_data
        if @@battle_loader.empty?
          pbMessage(_INTL("There aren't any teams in the Battle Loader!"))
        else
          loop do
            battle_mode = [_INTL("All Teams"), _INTL("Random Team"), _INTL("Random Pokémon Team"), _INTL("Former Champion Team"), _INTL("Cancel")]
            battle_mode.insert(4, _INTL("Copy Team")) if $DEBUG
            mode_chosen = pbMessage(_INTL("What do you want to do?"), battle_mode, -1)
            case mode_chosen
            when -1, 5 # Cancel
              break
            when 4 # Copy Team
              break unless $DEBUG
              names = @@battle_loader.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
              index = pbMessage(_INTL("Which team do you want to copy?"), names, -1)
              if index >= 0
                team_data = @@battle_loader[index]
                $Trainer.party = team_data[2].map { |pkmn| pkmn.clone_pkmn(true, true) }
                pbMessage(_INTL("Copied the party of {1}.", team_data[1]))
              end
            when 3 # Former Champion Team
              if $Trainer&.checkBadge(8)
                teams = @@battle_loader.select { |team| team[6] == :FormerChampion }
                names = teams.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
                index = pbMessage(_INTL("Which team do you want to challenge?"), names, -1)
                if index >= 0
                  rule  = teams[index][0]
                  team  = teams[index][2]
                  curse = teams[index][4]
                  #rules = ["1v1", "2v2", "1v2", "2v1"]
                  #rules.reject! {|other_rule| other_rule == rule }
                  #ret = pbMessage(_INTL("Do you want to use other battle rules?"), rules, -1)
                  #if ret >= 0
                    #start_battle(rules[ret], team, curse)
                  #else
                    start_battle(rule, team, curse)
                  #end
                end
              else
                pbMessage(_INTL("You can't challenge Former Champion Team, because you don't have 8 badges!"))
                break
              end
            when 0 # All Teams
              teams = @@battle_loader.select { |team| team[6].nil? }
              names = teams.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
              index = pbMessage(_INTL("Which team do you want to challenge?"), names, -1)
              if index >= 0
                rule  = teams[index][0]
                team  = teams[index][2]
                curse = teams[index][4]
                rules = ["1v1", "2v2", "1v2", "2v1"]
                rules.reject! {|other_rule| other_rule == rule }
                ret = pbMessage(_INTL("Do you want to use other battle rules?"), rules, -1)
                if ret >= 0
                  start_battle(rules[ret], team, curse)
                else
                  start_battle(rule, team, curse)
                end
              end
            when 1 # Random Team
              random_chosen = @@battle_loader.sample
              team  = random_chosen[2]
              curse = random_chosen[4]
              rules = ["1v1", "2v2", "1v2", "2v1"]
              ret = pbMessage(_INTL("Which battle rule do you want to use?"), rules, -1)
              if ret >= 0
                start_battle(rules[ret], team, curse)
              else
                #start_battle(rules[0], team, curse)
              end
            when 2 # Random Pokémon Team
              PokemonDataBase.create_mass
              team = get_random_pkmn_team
              rules = ["1v1", "2v2", "1v2", "2v1"]
              ret = pbMessage(_INTL("Which battle rule do you want to use?"), rules, -1)
              if ret >= 0
                start_battle(rules[ret], team)
              else
                #start_battle(rules[0], team)
              end
              PokemonDataBase.create_mass
            end
          end
        end
      when 1 # Export Team
        load_data
        rules = ["1v1", "2v2", "1v2", "2v1"]
        ret = pbMessage(_INTL("Which battle rule do you want?"), rules, -1)
        if ret >= 0
          name = ""
          if pbConfirmMessage(_INTL("Would you like to give it a name?"))
            name = pbEnterText(_INTL("What name?"), 0, 30)
          end
          curse = []
          if pbConfirmMessage(_INTL("Would you like to give it a Curse Effect?"))
            curses = []
            GameData::Policy::DATA.each_key do |policy|
              policy = policy.to_s
              next unless policy.start_with?("CURSE_")
              curses.push(policy)
            end
            curse_index = pbMessage(_INTL("Which Curse Effect do you want?"), curses, -1)
            curse << curses[curse_index].to_sym if curse_index >= 0
          end
          if pbConfirmMessage(_INTL("Would you like to give it a Custom Effect?"))
            curses = []
            get_custom_effect.each_key do |policy|
              policy = policy.to_s
              curses.push(policy)
            end
            curse_index = pbMessage(_INTL("Which Custom Effect do you want?"), curses, -1)
            curse << curses[curse_index].to_sym if curse_index >= 0
          end
          add_data(rules[ret], name, nil, curse)
          pbMessage(_INTL("Your team has been exported!"))
        end
      when 2 # Delete Team
        load_data
        if @@battle_loader.empty?
          pbMessage(_INTL("There aren't any teams in the Battle Loader!"))
        else
          teams = @@battle_loader.select { |team| team[5].nil? }
          names = teams.map { |team_info| "#{team_info[0]} #{team_info[1]}" }
          index = pbMessage(_INTL("Which team do you want to delete?"), names, -1)
          if index >= 0 && pbConfirmMessage(_INTL("Do you really want to delete it?"))
            unique_id = teams[index][3]
            delete_data(unique_id)
          end
        end
      end
    end
  end

  def self.get_custom_effect
    { :CUSTOM_INFINITE_SCREEN => _INTL("The Screen Effects will never end during this battle!"), }
  end

  def self.export_team
    load_data
    add_data("1v1")
    pbMessage(_INTL("Your team has been exported!"))
  end

  def self.get_all_teams
    load_data
    @@battle_loader.map { |team_data| team_data[2] }
  end

  def self.get_all_pkmn
    get_all_teams.flatten
  end

  def self.each_pokemon
    @@battle_loader.each do |team_info|
      team_info[2].each do |pokemon|
        yield pokemon, _INTL("the Battle Loader")
      end
    end
  end

  def self.check_legality
    method_object = method(:each_pokemon)
    removeIllegalElementsFromAllPokemon(nil, method_object)
  end

  def self.get_random_pkmn_team
    battle_loader_data = @@battle_loader.map { |team_data| team_data[2] }
    pkmn_data_base = PokemonDataBase.get_pkmn_data_base
    battle_loader_data.concat(pkmn_data_base).flatten!.sample(6)
  end

  def self.start_battle(rule, team, curse = [])
    setBattleRule(rule)
    TA.set(:battle_loader, true)
    TA.set(:team, team)
    TA.set(:curse, curse)
    trainer = GameData::Trainer.values.sample
    trainer_type = trainer.trainer_type
    trainer_type_data = GameData::TrainerType.get(trainer_type)
    if trainer_type_data.male?
      TA.set(:name, BOY_NAMES.sample)
    elsif trainer_type_data.female?
      TA.set(:name, GIRL_NAMES.sample)
    else
      TA.set(:name, _INTL("Unknown"))
    end
    begin
      #pbTrainerBattle(:LEADER_Lambert, "Lambert", nil, false, 0, true)
      results = pbTrainerBattle(trainer_type, trainer.real_name, nil, false, 0, true)
      results ? TA.increase(:battle_victory) : TA.increase(:battle_defeat)
    rescue
      start_battle(rule, team, curse)
    ensure
      TA.set(:battle_loader, false) 
    end
  end
end

module PokemonDataBase
  PKMN_DATA_AMOUNT  = 30
  LOWEST_PKMN_BST   = 400
  LOWEST_MOVE_POWER = 65

  @@pkmn_data = []

  def self.create_pkmn
    species_list = GameData::Species.keys.shuffle
    species_list.each do |species|
      species_data = GameData::Species.get(species)
      next if species_data.isTest?
      next if species_data.base_stat_total < LOWEST_PKMN_BST
      pkmn = Pokemon.new(species_data.id, 1)
      learn_random_moves(pkmn, species_data)
      pkmn.calc_stats
      @@pkmn_data << pkmn
      return pkmn
    end
  end

  def self.learn_random_moves(pkmn, species_data = nil)
    pkmn.forget_all_moves
    species_data = GameData::Species.get(pkmn.species) unless species_data
    legal_moves = species_data.learnable_moves.shuffle
    legal_moves.each do |move|
      move_data = GameData::Move.get(move)
      next if move_data.base_damage < LOWEST_MOVE_POWER
      pkmn.learn_move(move_data)
      break if pkmn.moves.size == Pokemon::MAX_MOVES
    end
    if pkmn.moves.size == 0
      legal_moves.each do |move|
        move_data = GameData::Move.get(move)
        pkmn.learn_move(move_data)
        break if pkmn.moves.size == Pokemon::MAX_MOVES
      end
    end
  end

  def self.create_mass
    PKMN_DATA_AMOUNT.times { create_pkmn }
  end

  def self.get_pkmn_data_base
    @@pkmn_data
  end
end

TEAM_DATA = {
  ["1v1_yoyo_p6BfYka1ZbVF9vXgN42L587w", true] =>
    "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",
  ["1v1_暗行队_45o2uq7hlx0anvd6cd18jruj", true] =>
    "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",
  ["1v1_钉子队_ar6t2fbydg83vwphr07u41pm", true] =>
    "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",
  ["1v1_多弱点反转队_f79o2v5juq4fn68igzythwp0", true] =>
    "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",
  ["1v1_反弹队_01j24hkx39ubaoisb78cqmrq", true] =>
    "eJyll89v48YVxy009dqWZflXNutF0m2dtmmbbkv5tzltyhE1orjiD5mk/LMp
    S0ljadYUqRUpe42kSQMEaVEgyAK9+BYE6LUoij0FaO897KHH/gNB0b+g176h
    ZUfeCLt19jDizHvk/Hjzme8bvTR2MK4ujuWOc6PiKHHUxakvPvn4i799/p+z
    T0fRiHOQDsXJSnhE22GgiBkp6tA6o5GY1k2npOrihHQYdttsRJzhlTptuLwt
    iHNSzNo0abgRjQVxXKIPO+wb/0LfFNOST4+pz8rivBTFtBO5cei2vLjegn4m
    weTFvUgcN0yDQLfnTTnsBXHibtKgQbtsFLqJWiw4LcJYXo35LD51Gbgegitz
    YRGn+TzzVUvRsAXD0Ydx18OJD1ZxwPsLoPsuFcSb/Rqfs8sHjQQYgsW0HR2M
    itOytWc7WNsmqgbmdngMn4+H4mw/NqKog2lcHJNYQ5wokKKpQGw6nV4HJj0G
    FTYDs+p03HbPj9loiF4bR98SZ2xsFPIath3VUNC32Qj6DptHi5f+bMXcKRAr
    b+r5vjc74J1SVAUXLKwag06+E6wbxe75HNPiRNWpWoaYJdhySltVXCboe+i7
    6HV0B2bUZbVaGPBITEj1MPSTENeo14tPWWLrxRQqEOu2142TWhz2mq1zW4vS
    IHkt8NoQwqzU8mClAY0ilvoLNDsQHLfm+b6YqZhlkseaJk5J0NMRC5pREhl6
    /E5avFGqsAUxjR0Hy2WoTUIAiWETeGPOrhBZxZp76Zy/sFy8lBUnwEQKyZzC
    k4B2Q3Hucl9MboBw+W/eeLL72T+QALRvez6HG82yGzAf3wuaPa9JoTEnhbXY
    Y4HbpnErbECP05cWr8NSv4fo9tsxsCSIsxfNC6RnpIRkOAj8gxF4gR8Ei9Yp
    O6YNmMQP/vuHFpDIraTZLJ2/zFE77EW8kpV6AXvQoy5rqIuvVfc3lw/Xjq2N
    vaXCdnv9fr24kjPC4AGfPsytQ7tRGHi+WoCes6++fQgRbcE8H8PWxmHs+eeN
    STDqCXhgb7Sb/XqW1y0asYjv7Cvnp4NzHFVo1+l1+d7OSzUvjn3YLzvuUu8I
    TFNSLYwi57QDWz6T1LdhGiwMEnjgba9+xFIf8KHoIQ0iylwOS8eLEzOvgoN1
    khqlDVaFlSRj8z45izeBkaDn+W4L4gCn/BAifevCFrW8xqV1+lwErND3I1jR
    vMSD6NZO3Y7vncIiwMKPMO9YboURDcTxArbKHGMW+1RdHEkiCdM+7HqsUYSa
    A5U4F4rzCkBd8GJPFBMTP3Jzql6xiG2rpoHzGoEIsoYb9No1UKQStCBCvssP
    g7o4p7Y7XX4SYH9qPk2Guc0jAuejAUrlwoohOOC+HHQpRB4fJVMhTlXDhoPq
    rI4Ag0yFxj3ANE6opcUQjRbRDTFbJJYF+mZaBhoHBZgQUFpAk4nKogwroykw
    ZtE0moHnLBtFc0U0D4+XxSm7asglbBMLvXIwgm4JaEFAt7nOWaZc3isRTScO
    ehUU7lxqMmUD7GaxOESkpvJmYS+JyhCNmi5iCxfwnowVMuxbjRC5ZMPhHfwW
    ff9gDB0hH7XRD2F2PwLPm1B+DOUulJ9A+SkUQUA5RtASWkYr0Fx9J43W2AJa
    h/oGPDfhKUKHCJ4/C9HPYTzpZSRIN/mxR29B+QV4JDjUCAsoD+GSoV3oH1FE
    BFQUkAJnsLO1rPqVlY22t+YIek7e75rrJ43NZrIZJXjfPPh3Gaks9Sd0j/+U
    YQUaFB26M6CYUCoC2oKHxRiy+TsOq6AqS32IttnraAcWuSugPQHtw2cHDvql
    mDZMS8ca+lWfUOQW0a/7eGTtHUIcx4SdB0BS73NCsvYJpXEchnHrKiNThmoQ
    SFzEviYimSLsSh4k92lCSuq2at8DxxVCpnTTNJJU9uU2H47mLhLZTkl1SFHD
    +jAK5mzZtOQS5ECeD4dhlC1YBOsFbMhXvgdQxlEPHaMTFD8flbeGoJIFVEYA
    lSygsvA1UHnjKirLwuoh0zeaK7tb+cqSd0+pPdz0aa50icrJ3xfPOCqPOSqP
    n42KBagwIOV9TsqnQEpjCCkoHMpIWsYWv1PU2S2OR1r2uiDhV9FIE93UFHwN
    Lka4dJjbxNrhCvEUGHMVS7V17KhyRcMOGWAju21qjr2jOnKpv3sTgxogm1qh
    aJmGM+wGRAxiKXv85vBVL7rTt830YZhA76LfoPfQG+B5Lg57T+GQBRwW+jgs
    AA4jgMPCiynH/vpG2WC5Vs96uOMvRatreldZ3jzFlzjc/uzDP3IczjgOZ8/G
    4QRwqAIOqUfAQxVwABkZphxFbY/v/DAqZnDeJoajq0YBFLcOnwAbM7gGeTFu
    88tz4yohk465iytk95rSMW0Rhe8bdsyn8guKBpOKYpE9Xb1UjMEDP2kRmYPW
    d2UGU4qmKiXHli1CjCHETDs8KVr2Drb0r2hF6j2U+i0Qp8Fl2NZNBaU++Hq6
    wVPMbD/F3HzxFMN6uf2WsrUhlI3lNZI/PPXXHyyVVmuXoIRv//NzDsojDsqj
    Z4NS5inmr0AK5sLxZyDl7v8vHBnFVCC5QOTrTOJ4TCnh3SakFtq9ykZGwaDZ
    pl65rn5YZlUp2WX413IVjfsDaMzDnUGHCxDkrsGbxRVlyFuqXM5DXih/6ZU2
    LkSlYqq2adzD+SGfziZ/heyKpiYLvXrzmBDTtmPhIkGpjxBc+CdswjlM/e75
    oFhDQOGKkh1QlBcE5cFJqbuRX9Zor7YZrq1vH9u51a0dY+UcFPbS7TtnWc7J
    E87Jk2dzAvph8+uDw97tK4p7DU6wU9IIiD1wMpfcUXHc8mnM6n1MYLJC7v7S
    Squ8u7zZy2NTjWrrG/WttpX8efkfSGVpJA==",
  ["1v1_飞行队_ba3rs5md1qmub4v6w80z7hyo", true] =>
    "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
    milG/A9qjlR3",
  ["1v1_猛士队_hw2yu43liduzw1elb689o0yv", true] =>
    "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
    7C7VqivLJVWJ7h5mqFtf29jUheMBn/Ev9DBFtg==",
  ["1v1_勤勉队_vdqblt859vo1tphg247iw0yu", true] =>
    "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",
  ["1v1_善战队_9c67ex5cgnlztm41t2zmv3yj", true] =>
    "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
    WF3KWQvH3cPF4T4f8V8hi2RU",
  ["1v1_守护队_v87djc3lx0g5gb4zu9kvlfb6", true] =>
    "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
    29XNck1vN9d4j38Brcl/vA==",
  ["1v1_束缚灭歌队_txdlqyghs8290wfz46n7i1ba", true] =>
    "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",
  ["1v1_幸运贵血队_h7y1uar04l362nqyesrutx8d", true] =>
    "eJzNl1tzI0cVgK0iaH2RLfmSTZwiCTGXDSQsI9vry5wQNBr1WLMazWhnRpa9
    XlCNpLbU69GMdmbkWLsp7lRRUEVRRUHxlgrkJc+BquWJVx74AfwBiuUReOCF
    2+mx5PUuKmeXSxUPrek+fTt9zndOt56ZPJhSVyazx9mkmCS2urL0u1/ef/Cr
    Hzz4+S8evPu1P/zknSRM2Aczvpiq+Ee063uKOJsLe7TJaCimdwy7qNpE04g4
    nTv0gy6bEOd5pUlbdd4WxMVcxLo0btRDGgniVI6e9NhHfgsfFWdyLj2mLiuJ
    S7kwor2wHvn1jhM1O7hOCkVO1A/FKd3QCS572pT9vhfF3W3qtWiA1Zlc2GHe
    QMG9nAZzWTSoM+w6YUnUdSgRZ2RN1Xf2cSd6EgWOFIvxEAd8KQ9XDqggXh7W
    uLp1vl8o4Oosot3wICnOaUSxjV1iWijs+sc4ecoXF4aGEcUyiqbEyRxriRlN
    3SnalmwSoqNper1+DxWdxApbQqV6vXq370Ys6cOLU/CSOFskkpZHO8LH2QS8
    wqZh5awvZRJFI7I97Fo615WxaoTYFtGITs7P5D5gQRjVh0rCy/AJ+CR8CncO
    WKPhe/zU07mm77uxJRvU6UcDFsv6ET01adcJorgW+f12Z2hmSr14mOd00Vzp
    XMfBE3k0DJmDrR5aot5wXFecrRglkpc0TZzL4UJHzGuHsQHo8b0Z8VKxwtLi
    jGTbklziGhSIQnSLsGVx0aoQWZW0+lnn0kjycNA0ikghVsl/y6OBLy6eOcHg
    AjSO+9ql3+y9+2u4inTvOi7HGBbYJdTHdbx232lTbCzm/EbkMK/epVHHb+GK
    mTOJ02OJ76Alh+0IsRHEhVFzBO58LuYVcecTJnAAx92kTcqOaQuVePUv3+0g
    dFxK2u3i6WBO1WE/5JV0ru+xO31aZy115UVlo9BcN3rdtfI1b1AzV4vbWy2/
    cjvL1UfdejQIfc9x1QKu/Oc/irfQoh3U86/o2ciPHPe0kUJhOeYL5a1ue1hP
    87pJQxZyxz53Gggc2rBCA7sfcNcu5RpOFLnoLysKqHOEorlcww9De9BDj8/H
    9V1Ug/lezA6OdppH7A2+Ez2kXkhZwFHpOdERBgKvoZy9HdcobbEKniPema/I
    QbyMhHh9x6130AoYyYdo5+dHsrDjtM6kmdNAN33XDfE8SzluwnpjUO+5zgCP
    gBIeq3xhueOH1BNndMMsSxqnmEUuVVcmYkui2oeBw1oK1mysRFlfXNpBpgtO
    5IhiLIrjUtV1Qya6jbZjrbrX7zYw41zHFtrGrfMoUFdmVc/zm9SL4qVf4GbA
    kGhhDqrjOdEiaCrFh6QCl8RZqYLpQ5V0mMJwnRZgRoBUnAxhlpVgDoVpyMA8
    fhewLCqwhJ9nxZRSNWVDsuG5gwl4XoBlAV7AjJSRLEuqavYusWz4GGaj07yQ
    LkhmCYOvapJxWcMuVvUCMfOGNi6ppFSZ5IlUHtOV1qplVc9XTWs0cZ73wqcP
    pqENHWBwG/c2cXJB0mUCV1DZV3HcZ7B8FstrWF7H8jksVwX4PLsJAmRhFZtr
    92ZgnS3DNaxv4HcTv1ssDdv4FX0A3D73LFzNXeZBDG9g+QL2vIkhCl8UIIe2
    k7Cdx7C4ggEHsgAFAQhGVE3Zvx64q2zj7tbJ5raQV9ezx9Wjxs04ISjsmb9f
    +f3rsMMS70CR/6h4nOtYMPOAhqWMRRfAwE8FN7nBEm+DyTywWOL7YOMBqnjG
    XQFqAuzhtH0bbsIB3BqCBl9S4Ms+1GOWNCKh1bV9cNgNaCA3GkW2A3cQj2yO
    EEmXdVUntqQR6ykgSSIkGa26VzX3bcmyyaOgwOE5OhYqKjFlvAwLRjU/cmT6
    nJsXLdkw5SKOsCS9YI0ZMVkke2PEU5Ym7ZyXIxlTEEAP7oD/4TRoY2hYRhom
    kIbl/w4Nq6625wt6tlkg4aayvTUoWo07a9e8EQ1/I8dvchre5zS8fzENTaQh
    RBgSP0Ia7iIM4ZPDkClLloEmtmxVRh52OQ+ZshP6+PTB7Nx8FInZskWkEvrj
    KbNGRjXx8VC1pbz2GBBi2rJNtUQeSxzzZdWSCruY8ManjrmKoVqGfl3Kj+mc
    LZiqpplVfdzEmmQTU5HOXjjzZ3i8BScwgLv/Ph7pIR4T/zkeR2u7G7ToKevb
    J5urTsm83RWygVozRnj8afnbL3M87nM87l+MByaTG4iFyTOGxSrIR+vJ+Ugp
    JrGVqoZsiJyNlBLQ6LDvPspF6ikuk+TDPLGEbrCLkr2jqTZ6xbogV2Rqksrf
    zXnNqI1zq2VL5UrBqOnn3TqaW+J5TJV3TLXycO5hMjviRS5KcZY5v3CMxFfg
    q2Iaew2rViREg8S9/4urZJtey2rt47XSKjPklrC+tVPTw2Kze0oHjt+svvQP
    jsd7HI/3LsbjBOnoIB0lhOMWwpH48ZPTMS8buox+kWzD5NfJKxyRedn3mvin
    xon84LErZU5XC8aNKv4XeUpSZne0qm0b+v5jiByfzxmKJpWJXTSNGjHHYDCH
    iJmSgu+wMZ0zZVWyytK/ooV3xqP3yDQkvg6Jb0Dim9AT5/JGYb9iEsv6cDD2
    //dgBIeCedcr3pby2fWt/c1VBKXqHlVqZ2D87Hs//CkH4wMOxgcXg6EgGAGC
    wfgb41tIBnuKtKHqNv+PhEyU4rShevwBSoc4oKqdzf1sXzKFdW1tY9W7M6BW
    ULX3tlp8xD8BUBRRzg==",
  ["1v1_幸运畏缩队_0lbnpjuwgw2iin83jx9c5a74", true] =>
    "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
    LlN1d+OFk73qlrCzyWb8F+VViLI=",
  ["1v1_隐修队_6clxlubeiq592fyo80tvuf74", true] =>
    "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",
  ["1v1_原野队_u659e7no4kaxqcl3hsbj02po", true] =>
    "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",
  ["1v1_战术队_4ui02xkum3yzrse1tog5t68y", true] =>
    "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
    479t8Txp",
  ["1v1_重炮队_70pcwxbgnm21b534jgrd6hyk", true] =>
    "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
    SjdWl1dutvuttc5wn8/4N/lUWnQ=",
  ["2v2_yoyo2_fbpOg8Y435kid6J9I7U1HSKe", true] =>
    "eJydmE+MG1cdx9dQNtld/9l/pElFS5qCigRF3k2yyb7Xgp9n3tgTj2cm82f/
    0prxenb9urbH9YzTbAqqhCioF1RAINHeoBeKBNciOHHpAXFA6gGJM+IGElcO
    8H1je7PZpGnaw3je39+8P5/f9/2eHzu7O6NfOrt6a3WaTHNPvzR7FB1Fq9N0
    ytudi0jWjg7DbtTTSa4U98M9EcYkpxhcY2WDk9nSfjToiimyIBN7Yash80Wy
    VEpEN0wzjThMimSmFN7ui8/+jX6OzJU64a2wI2pkuRQnYT9uJFGjHSR7bdjJ
    oihIhjGZMS2Tw+woq0TDXpJWH4S9VjgQ0zATt0XvSMO3gqboiOSoIVB1G1W5
    SQnJGb7JHN3y8K3wdjIIWFqBSexKYz3YHoRFcm6ckgNuyC/GRdgXSdiNd6dJ
    weC2zcrccbZR2o1uofdMRBbHK0NIHUVnydmSaJF5xXLrumJbm9zB6vT7wz6G
    fRYJcTaiT56lT5F5d5Nzz+UGNzm9KKbo02J2XJXfZI5qO9x1xxWFcUVOswzD
    2qxPOizLBReDOGmMhrNMco6l1DyrXia5umWZFbQmBVvf0rntm0qV5FyPORoz
    DFKoc49bTp25KK2Z6GZpGsnqCi9zVqdfJAv1bdfTFWZousNJ3jbYtmP5lSqZ
    d3RXNyvp5OgzJMvqJnd1Rr8EShzL44qHpR+IZjPqyfWdLe1FUSfdtWYYDJMj
    kZYNkxAJbF83GCRpKomGB+1RWTsMe2mzXtDFxhRK7QBL1wvjWGT+h2wfa95o
    Bp0OydlWjZflhPIlWDoUvYM4Xerw1mtz5EzVFhfIHPM8ptTkEFSucdPlKFxy
    ba7ozGgcVy5PSiaNCmQWRVxNxxS92gsHEVk63m5LFszQp7AT6/qlKekpdFGc
    wTg6Qe9gGByEyCyVomYSiF6jGybtqAVL88clQV9kfogdHOcTkFkki5PsyDue
    QX3qFPAp2WEKDaRPOeFeKG6Frc5XzyhrrA2uZSk/OKiOGktw94exTBRKw554
    ZRg2REu/9KQevdK8XNWud4rx2lbo7Vy5+vLNFbFuyeFjbP1wEEe9oKOr4rEf
    /X39EhayjWH+CTuaREnQGWWyKKwPO0nqZK3uwThdkGknjEUsN/TxkatJr4jt
    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
    Y12/5q9U3Vo6mP8D7Kq3oA==",
  ["2v2_光辉队_32nk07wmd4gqlppbqy968slr", true] =>
    "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
    p7nWuqWVutu71a2NG4Frijf+BwPRUqE=",
  ["2v2_和声队_v3oa9fjwn025din87zcuqm4v", true] =>
    "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",
  ["2v2_活力队_lqzh8tuunj6a93x07mlhm14j", true] =>
    "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
    b6zsCBsltdVZWj3i+/4Xr0xP1w==",
  ["2v2_奇异空间队_dle4cstkx1g60j2eky538aqu", true] =>
    "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
    /BdVRX+i",
  ["2v2_日食队_m8lwx2seaz351vjyo9lte0q6", true] =>
    "eJy1l81zI0cVwK0iaC3Jlvy1mzhFIJgASxLY8bfdvQkzGrWsWY008szI8gdE
    GUktqePRjFbTcuxslhQVCBQcOUAVRW1RFH8AxSWXFFW5LAcOHCkuHKiiKieO
    XDjweixrtV4Te/k4tKb7dffr169/73XrmfGDmLYwvnS0FEVRYmsLyb/99Nef
    /OrBJz97EMVj9kHCRxMl/5B2fC+LJuWgS+uMBiiZMcuZjLZlFFFcbvq9DhtD
    06JSp42qaEtoVuasQ8NGNaBcQjGZHnfZZ/6EP4sSskuPqMvyaE4OOO0GVe5X
    2w6vt0HPBIgc3g9QrGgUCag9bap+3+Nhd4t6DdqDakIO2sw7ycJaTo25jJ9U
    GXQdsyiYOpCgVIXoulXWbJKB1egx7zlK2AX7OBDqPNDeoxK6MagJk6tizUCC
    FRinneAgiqZLWrFkaEXbNNQ8yDv+EcyP+Whm4B6ECiCKoXGZNdCUZRNFt3Ph
    4Ljc7fa7YO84VNgc2NbtVjt9l7Ooj1+I4c+jVI7omlFSyhbBL7Ix/EU2jheG
    vRMl07CJal/QFTOJdSaPC7k4BdYLePXUvjiaSZtEyWvFLauilQj+En4JfwF/
    GWzosVrN94QL4nLd993QtTXq9PkJC2V9Tk993HF6PKxxv99qD/xOqRcO85wO
    +C4ltx3Ym0eDgPWh1QWfVGuO66LJkpEnaUXXUVIGRYfMawWhK+jRvQS6liux
    FEootq2oeWFBhmRJ0SJsHs1aJaJqil4dds6dSR4NioOIZEKT/Lc92vPR7PA4
    DCEAJ7mvXPvD7i9/j28B5zuOK7DGM+wa2OM6XqvvtCg0ZmW/xh3mVTuUt/0G
    aJwaSpwui/wQHDtoc2BIQjNnzTOSp+UQYOBfTBiDAYJ/k9YpO6INMOLmP37U
    BgKFlLRaudPBArFmPxCVlNz32N0+rbKGtvDCslRbvWMvKZvqxtp2q3l85K+z
    vZyTFeaDbV3aC3zPcbUMaP7Lh79Lg0fbYOcv4GS5zx33tDEBwkJIGsgbndag
    nhJ1kwYsEAf77GlUCHyDEu3Z/Z442jm55nDuwnlZvEedQxAl5ZofBPZJF058
    OqzvgBnM90J2YLRTP2THYiXapF5AWeQDwUrX4UIsatBxJqS0wW7DTsK1hU6B
    4g1gxOs7brUNfoDgboKnnzuTBW2nMZROnca+6btuADuak4UTq7WTatd1TmAT
    IBGhKxSrbT+gHkoUDbOg6IJjxl2qLYyFvgTDmz2HNbJQs6HCF300twVUZxzu
    IBSKwhg1SVaHKNR2CPiPNapev1ODNHQILfCPWxWRoC2kTNp0aZ3DoYfqnxfO
    gMBoQGqqwl7BL+CwrI+jWXwNTVq6URHRiWMQw3EJJyQ8EeZIPMnyOAnCFJ7C
    0/CdgTKbxXMsiq+jCQhqXYPQf/ZgDD8n4XkJPw9JKqmTrG3sENPCn4PcNEgf
    A8MHaWJuJH3A8hBaRjY76Jt81Ad54oJMRFRdKw2TVEp04a8cJDBDk1lDh70U
    CEpWFDNTgsRk4bdASxvfBBu/BhNehvIKlFehfB3KN6DckrDE3sSLeAkvQ3Pl
    XgKvgt41qK+zebwB3034IvhiH98GI+Tr+JZ8Q0Qwfg3K69DzTYhPLEtYAZel
    oa1CTHwVog1nJEwknIVw6vC3KusbXmNzv6yvFLYXreWlo9WT9l6YDbZg/F85
    4jjHIr/Bmvi5AxvLQ9FBXQFKEYoh4RJ8tlkZm+xdbDEP2yzyW1xmN/EO7LEi
    4V0J78GsfRsf4G/hbw8Yw29kcdXHbwoXxi3b0FRcY5F7uK4txC3us3o4qDGE
    Qi+bStHWrKtAEX0ERapk6Iqp7QucHuciZdmmlic74rJ4BMacRVST2HC15Ira
    dpmM3iNnF5OlKjrMgsgZPfNBL+CmZEc7R6dOV4hi54iZLpvDK+oMmDiaUnUD
    ljcKacWGVcolYpaMCjFxgO9ifjky3jlk5gGZeUAmBcjMAzJj/wEyNx9Hxlij
    24XV+v5dtlte9530SmtDWnwns3mKDHtm+cOHLwpiPhbEfPzpxEQeADJNQCby
    XWDmGJBZvzoyk0rGMJW0ToCaawKaSaXh95yaSx/nZgKym1JQzKfAZgywmVQN
    eNUo5t45aKZUc8+yFX2HaPoINYktsmfBQT154hMVYlcMM38BKVOGqpZ1W7E1
    o/hkHsJHo9qAj3F8H9/D716OAfk3GIwNMEj99xgsSmlmHt4N1veXNjaPV/W9
    +om97Kq5YeZYSdymgoOHgoOHl3DwAXDQAA56gEETMChfgAGKZRTw4kUozECc
    ZMUlZBRF9q+BLuBhBm7tprhz4CYO+HkoNN2wIeM8HRTXMyagBPN0bStnP5FR
    cHeEiKmsrlg5VSkWLzzc+xddPIVyxtK1DLmAlVRFseEGKxll+xwWMdAVeQ9H
    voMj9y9n4/X/f4rYcFtWfTm/sllc3Fo76Qa7OWmVeG1lyMbLf3/t51fNEW8A
    Gl2RIn4srpUfABz7V88RyQxRiWZnyzpA8aqAIpkRT0/e7Lvnbhc1pxUg5RtP
    8eQQRMTTpmblz2HQGsEgtqdUik8+JFAyB2+VUlm3Ri6YZnRx0BuHx7yxNeiZ
    HkVETEvDf7dzECSwiyGMIt8XDxtVPHZw5H0c+d7lQJgXADH6zPgfJIvmXm/p
    jrW5qG2s9Z005SVlZfl4ty4NgfjnH1/6swDiIwHER58OxO3BM4MJHn4CPARX
    5yFlVQhc7YZh58Rb4z1BRMp6m1LOfZ+3B0iIh9GGW9ldCojzzvLq4s6dE39T
    t6m0vSZG/AtI31K2",
  ["2v2_沙暴队_3xk4yrcumwz927z56ag0fvid", true] =>
    "eJy1l1tv48YVxy009foqry/ZS9KkqXvbJk2Xltc3TpqIokiJK4rkkpS8ttuy
    lERLU1GkLFJeazfb9iVpUexbESBdBCj6BfLQ9BPsUx/6AfoJAhR9LZC3ov+h
    ZcM2lK63RR7GmjkzPBye+Z3/HL80sTepLE9kDjPj/LhkK8vpz//8h8+f/uUf
    H/9xnIzZe9MhP2OEba8TBjI/m426Xp16EZ82K5pkKoWKxU9l98Neh47x86xT
    9xoOG3P8YjamHS8ZOJEXc/xk1jvq0q/9nXydn8763qHn0xK/lI1irxs5cei0
    3Ljegp8ZmNy4H/GTmq5JcHs8FMN+ECfTTS9oeD06DjdRiwYDGe9ya9Sn8cCh
    mDrC1OyJhZ+zBC1v2aYklPE27yjuuUIyhe/YY+4CeO95HH9t2GNbdtg7Iw5v
    oLHXifbG4aas63bR1MUSrJ3wEE9PhvzCMDg8X4Zpkp/I0gYiZuq2JNqITbfb
    72LTE+jQCeyq23U6fT+m4yF5bZK8zqcNQdEsQ1Vs8gYdI9+iS2T5dPKqZUuC
    evzSEdPpnJ7fMUzJsoaTc2ySnQPtRbFzvMcpPr2tqKq+rVgG+S75Dvk2+Sb2
    0aO1WhiwAExl62HoJ4GteW4/HtDE1o89dBDhjtuLk14c9putY1vL84JkWeB2
    ELm5bMvF9wVeFNHUhxh2ERSn5vo+P2voJSknqCqfzsJTmwbNKImHd/homr9S
    NOhNflqwbUEs0Sv8TF6SJc2SYFy0DElUBNU5nVw6sZwsmuWnYJLyyZ7CB4HX
    C/nF0/PQmQFh8t+68rf7f/oruQ3Mq67PqCYLcJfO+m7Q7LtND4PFbFiLXRo4
    HS9uhQ14vHpqcbs09VtEdTiOgRDHL5wMT0Cezyb8An/2wBgWMPxNr+7RQ6+B
    Tdz64nctAMisUrNZPF7MCNvvR6wzl+0H9KDvObShLL+2ltvsbqxb+orWD5W7
    9/3SasAdHmy12faxt67Xi8LA9ZU8fenVB947CGgL23yKk43D2PWPBzMwlhPa
    YG90msP+HOubXkQjdrDXj3OC4RsZXs/u99jRLmVrbhz7OC4r7nluG6Z0thZG
    kT3o4sTnk34Vu6BhkLCD1W69TX32Jm/fCyKPpp4xVrpu3KbvJT1M0NQHSdfz
    GvQWPiR5N/PJULwGRIK+6zsthAGpvY9A3zixRS23cWq9epz5Zuj7Eb5oKcti
    6NQGTtd3B/gIWFjiMsdiK4y8gJ/WdLMsqIxjGvuesjyWhBIb3++5tCGjZ6MT
    r4T8UgFU593Y5fnElOSatSPqRlHQbISPNpyg36lBg1K/xhDx8R2WCVBPa1AP
    uy03iBPvr7BYIC8a0CUHn4qwIF5ySMZlAgLLBaUgIPWLZBL5O8WRaY7MJApJ
    ZmmJpGGcI1fJPH4X6DhZlMkSfl5mmSCIkqLZkqnqhmSS63tj5AZHbnLklUSq
    bFMpSVXJssk3IFJDMWEqIqiCJhalEWKykINClhStYG0rxsmC+fNiZFYKBVXK
    VQqjtGpX0oqSkM9VbPvs0+R7e1OkRSj5BT8vmjuWLajwIZRJm9zCrn+AlW+i
    vYX2Q7S30X6EdpsjHFXJCsmQVQzvPJoma/QmWUd/Azq3id8tjHn8kpC8gx1k
    Xya3s9dYapMfo72LmfeQuCTLEQHBzGEsDtOQ5DkicURGnu1v041BRVtblw92
    uXL/6E61vWmtZtxEJgpY/+q/4g9JkaY+Iwr7cxdfVEJT4a6MpqHpHDHwc486
    xKR9YtHHxIYOkgrdIFV84zZH7nNkB0/t2mSP/IT8dEgf+ZlMnJD8PIm/Jamy
    qGuWqOgVi9TgqK4sL1qev/92HUpdp2E/Sh5qnPAzZwAAXVZ3bOkyAI0dAzQG
    gBYEs6ybhiKZIk78PD6keQaaeQPcFxVRFgDG2Vvm5AoqCmbeUEHjiMlpECPI
    I2FTNFkyNV0pA+RzNx9wmSRdANMj0fMBSf1yBCE3h4TcBCFj/wMh3z9PSKGf
    28xsxL19/WBd21JXqCKGq7trg1NCPnn4xT8ZIZ8yQj7974SkPgIi+0DkARBx
    QEjqyeURSYu6qqKs0E3g8TrDIy1CAL16HPbOk5FGAZLTDQGVweWVhYExVxYK
    mmTj3IwLonIVzoSKal9UFVkwhbywIwqFUQc9V9VVG4pii8Xh7NRZerYZPRcL
    mJNHJcG0i4a+DX07D8gUP2frANOumNUdMiAPyRF59HxY3v/q1eTu2vrBRtxZ
    NfqlrXuuqe+vbLZ9JbN9ykomdf3ZZVkRgErq92DFYXLyGWDJjGCFn5IFxdwZ
    DYxhIr0UUVABTDMBxui59ZjWh3XQKTDTUJGCrr0gLfN5yZJM2zIUE/Xrl6vI
    Ql6q6hUTUpOvWKMK3RncKbnK7u6oIpfdkXkTVfIo+UFG5GVT1y5qyARJPSap
    XxEIxHO5ePcr0JALXFTXH65u3vXbBa6bMVudNVWoDezSytYpF9nHNz5hXDxj
    XDx7joa8DzDa4CL1FGDsgovg8hoyg6zSWArXQBOAmJHcHur2+DwOs2WpIGhK
    pfyC98qMLKDsUNQL2pFWJdnWq5JpnVUO9j+ZVrCLFrRmhDbgbsPtgaJtRC0y
    L5h6WbCLEnRqZ9TDqERUo6Ja0tnJYy4+ILiaU795Phfml+jF0lAvlv7/uyXM
    mPFDf2uNu3fQW9/Ot1dsa3Uz1ymfcvHv+2+al+Ui0Ysn4KLB9OIJuNh9gfJD
    1MvsvlB0TUA5UaNvMDoWxLDTdSNWtLqxN2QE+149Kt3Z6dUr5Qe7W5mNh2vr
    QpOTq7TBVvwHL2ZiNw==",
  ["2v2_月光队_ta4fcgkbtexqy7hv2mw18506", true] =>
    "eJy1l89zI0cVx60ieNeWLck/solThIADJBAWxl7/2ukAGo1a8qxGM/LMyLZs
    iBhJLavXoxlFM/KP3RAuSSVQQKVqK1UcqKIoOFNU5ZJLDpzgwJED/8BS4S+A
    Ki58eyx7vbtmf/Cj7PF0v9fT/fq9z3vdfuby7pg2f3nxYHFUHqWONp/66y/e
    v/vuj/7281+OkhFnNxnIE5Vgn3UDvyhPZsMea3IWysmyVdbKVB7PtoN+l4/I
    U6LRZK266EvyTDbiXRZ36iGLJHksy456/DN/IZ+Vk1mPHTCPl+TZbBixXliP
    gnrHjZodzDMBkRsNQnnMMA2KaU+6ajDwo1i9x/wW6/NRTBN2uH9cwFpug3s8
    Oq5zqI4wavJUIk/lFMvSqFVWStTCeuwo6rtKrMQ2dsWEPubvM0m+MmwJo+ti
    1VDCGjxi3XB3VE7pWnHdUXWlBmE3OMDHY4E8PXSNLJchGpMvZ3lLno6HGppR
    tHWlDBf1eoMerLqMBp+Fcb1evTvwIj4akBfHyOflac0oaIbm0IJpqZR8gY+Q
    L/I0mT8bkClpBmKjFi2tMlTPnlfHC9qqRalxXi2CwvthVD+xN0m+FC9FLcPU
    yhVFdeSJAvxiVh3yZfISeRmm9XmjEfjCMePZZhB4scsbzB1ExzyWDSKGBnzf
    dftR3IqCwV7nRNZhzI+H+W4XHk1nOy627LMw5InfoduDt+oN1/PkyYpZojlF
    1+VUFjPtc38vjF3EDm4n5UvrFT4nJxXHUdQSWhN5WqCGTXlanrErVNUUvX6m
    nD2VnA6CARDRfGxTcOizfiDPnAXKFAJ4zXvt0p+2f/VHIoH+TdcTsJNpfgn2
    eK6/N3D3GDoz2aARudyvd1nUCVqYMXMmcXs88T5cPOxHQEuSp0+7p4hPZWOy
    kRjigxEMEIlhsSbjB6wFI175+487AFNI6d7e+slgQV57EIpGOjvw+ZsDVuct
    bf7FnRWttVqKlpb3Fp1A2qA3Fjz/+q0wJ8yHbT3WDwPf9bQ8ZpbnihY82oGd
    nyC0URC53klnAsJyTCDkre7esJ0WbYuFPBSRfe4kWQTYYYX1nUFfxHY223Cj
    yEO87KjP3H2IUtlGEIbOcQ8hn4rbmzCDB34MD0a7zX2e+FAsxdrMDxkfCFh6
    brTPa3ELcrhKtBhr8To2Ei8tphQoXgEi/sD16h24AUnfhqOfP5WFHbd1Js2c
    1AQr8LwQG5rNCh/WG8f1nuceYw+QiIQWE6udIGS+nDRMFAddcMwjj2nzI7Er
    YXe77/JWAS0HjWghkGeLoDrvRq4sxyKRepM6VfLU0mtwHm/V/UG3geK0gR6c
    49VFHmjzkzqDjX3vOJ76BeEGJEUL5aqOfcIj8NXZQosBccXMKaWc0xzNrNqk
    yVMEwU8p3QbKVjAIY1hZISCjBXJJTtvAXstRXadkDNk/LpGkRCbiYksmeYmk
    IEyTDJnCe5qPkpkCmcXrWTlj0SI1qKU4pkWe2x0hz0tkTiIvxPWOFhxzk1o2
    +Rwq3UmhSW0pVr5iUdu+oEhNKGWD2poyVI2dV1lUFXMNVZNkvj26MNRNrlNF
    F8YPlePiO/KV3THiEZ905UzBVKu2sLJYI1+FjV/DsNfwfB3PVTzfwPNNPJJE
    FvgeWSTXyBK6y7eTZIXPkVW012Dodbxl9AnerwfkW1g7+yyRsldE1pNv4/kO
    NFnkNFEkkoPbVPRFHr2KDCVUIgWJFJGCbNFZ81b39aWVW/mdjeV+U7q5qUal
    hTgo6yKjzZfuEI0n/kBuiD8lbEfHU8Z0Bh4TT0UiG3hZ/HVi88Qd4vAWqfLE
    b8gmJFvY5LZEahLZwWe7Dvku+R55Y0gmqRfI94eIZBAKhxqnkHQEJJlKnwGp
    CzBJKbpZxo+uPAUlI6AkVTY127FxBj3AyFRZsyzTonnLVEvnMEk7ZsWuOVVr
    s/bwaYWgngv0vRNso6rlFWzFuOCAS9kV04kPuaFyagjJBInkTN5SijkAojjr
    ckrQVKnqNq4OsEFd19SCgoOYvEwG5ODx/FgP8JMe8jP3v+Pnhr09aC8vmDsr
    q9Lahnp0yzu8fvPam8YZP7nxX/9D8POp4OfTR/NTBT9vAZ9F4HMIekpPTs+4
    vW5u1cDNseBm3O4Eh8f3E5O0qLKJyvAEuIzcKyppzUCyxll7Py/k5jlGxnFa
    m8Xz4TxFwXZwc8LvDSU3VM+dV+eqqHOOYynaRaTMxEE3bVWz7XsspYe4TKJI
    FU1D26Fy0sYUBVBiCKwKqD9YkiRuy7NKXikrSCqDnlS6H5C3MbpEt1C/HstP
    6YL6MzesP3PgZ+Q/4OeV+/lRcnRBOl5zD1dXtkrG8lGn1Wbbi9eqJ/zwZ37/
    z9qrAp+PBD4fPRqfxG9F/fkZAOoAoPrTAZS2aEGnqqNtUlC0LyhKW6ztsWaE
    u839KGWKeQXnLC65igGeRp+cJ/LWA1Uno9i2UtWdTWo754tOTFxOV2znggIj
    ThlnS9m86Hadsqs5XSsrDr3gw+kK/ntQwUberOacB3i6TBLvksR7JPHO48mw
    /w0ZI0My0v99ZSms7LSXpev7xlq/Uups97TVraVrjZuts8py584nfxZo3BVo
    3H00Gm+AjBBgJD4UJ9MPgcbVJ0djyqZ6gRYKivAc4DgQcEzbzGtfZe2228T1
    8X4+xhUrZ5ae9vqimgbSWFMfvr6khbxEH2BkylaMfIyIMOvhownRfAgPknj7
    ImYqOBNN416Nmh0iMY7xWF2v5os05k0Q8hOS+OnTnz3/h9pRKNaijTBvH/gr
    +4PlhbXW0jXzutFbPCNEvbWdFYR8LAj5+DHF4wNRPN4RjHwARnaASOXJEcF1
    UVNyuigdSUHHhNLlbsM7rRswNnKX2s3ifs6hRxu11c7mYvlwYW1ZWhEj/gX0
    xXzs",
  ["2v2_忠诚队_b3ba5t6yjh8izp4ua712xftn", true] =>
    "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
    cdleOdrsrNFdY6nqrs4vHLYijY34D2TxSzU=",
}.freeze