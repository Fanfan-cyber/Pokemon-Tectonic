=begin
ABC.class_eval do
  define_singleton_method("abc") do
  end

  define_method("abc") do
  end
end
=end

module TA
  class TA_Vars
    include Enumerable

    attr_reader :vars

    def initialize
      @vars = {}
    end

    def set(var, value)
      @vars[var] = value
    end

    def get(var, default = nil)
      @vars.fetch(var, default)
    end

    def increase(var, increment = 1)
      current_value = get(var, 0)
      set(var, current_value + increment)
    end

    def each
      @vars.each do |key, value|
        yield(key, value)
      end
    end
  end

  def self.get(var, default = nil)
    $Trainer&.get_ta(var, default)
  end

  def self.set(var, value)
    $Trainer&.set_ta(var, value)
  end

  def self.increase(var, increment = 1)
    $Trainer&.increase_ta(var, increment)
  end

  def self.find_pkmn(species: nil, form: 0, shiny: false, place: :party)
    return unless species
    case place
    when :party
      each_party_pkmn do |pkmn|
        return pkmn if pkmn&.match_criteria?(species: species, form: form, shiny: shiny)
      end
      return
    when :pc
      each_pc_pkmn do |pkmn|
        return pkmn if pkmn&.match_criteria?(species: species, form: form, shiny: shiny)
      end
      return
    when :all
      each_available_pkmn do |pkmn|
        return pkmn if pkmn&.match_criteria?(species: species, form: form, shiny: shiny)
      end
      return
    end
  end

  def self.each_party_pkmn
    $Trainer.party.each_with_index { |pkmn, i| yield(pkmn, i) if pkmn }
  end

  def self.each_pc_pkmn
    Settings::NUM_STORAGE_BOXES.times do |box_index|
      $PokemonStorage.maxPokemon(box_index).times do |pokemon_index|
        pkmn = $PokemonStorage[box_index][pokemon_index]
        yield(pkmn, box_index, pokemon_index) if pkmn
      end
    end
  end

  def self.each_available_pkmn(party: -1)
    (party...Settings::NUM_STORAGE_BOXES).each do |box_index| # -1 is party
      $PokemonStorage.maxPokemon(box_index).times do |pokemon_index|
        pkmn = $PokemonStorage[box_index][pokemon_index]
        yield(pkmn, box_index, pokemon_index) if pkmn
      end
    end
  end

  # 可允许被随机获得的精灵的精灵池
  BLACK_LIST_PKMN = []
  @@pkmn_pool = []
  def self.all_available_species
    return @@pkmn_pool unless @@pkmn_pool.empty?
    GameData::Species.each do |species|
      next if BLACK_LIST_PKMN.include?(species.id)
      next if species.mega_stone
      next if species.flags.include?("Legendary")
      next if species.flags.include?("Test")
      @@pkmn_pool.push(species.id)
    end
    @@pkmn_pool
  end

  # 可允许被随机获得的特性的特性池
  BLACK_LIST_ABILS = []
  @@abils_pool = []
  def self.all_available_abilities
    return @@abils_pool unless @@abils_pool.empty?
    GameData::Ability.each do |abil|
      next if BLACK_LIST_ABILS.include?(abil.id)
      next if abil.primeval || abil.cut
      next if abil.is_test?
      next if abil.is_uncopyable_ability?
      @@abils_pool.push(abil.id)
    end
    @@abils_pool
  end

  # 从特性库中随机选择一个特性
  def self.choose_random_ability(pkmn_battler = nil)
    return if pkmn_battler && pkmn_battler.has_all_abils?
    loop do
      random_abil = all_available_abilities.sample
      next if pkmn_battler && pkmn_battler.abilities.include?(random_abil)
      return random_abil
    end
  end

  # 从玩家队伍的所有物种特性中随机选择一个特性
  def self.choose_random_ability_from_player(pkmn_battler = nil)
    abilis_pool = []
    each_party_pkmn do |pkmn|
      pkmn.species_abilities.each do |abil_id|
        abil = GameData::Ability.get(abil_id)
        next if abil.primeval || abil.cut
        next if abil.is_test?
        next if abil.is_uncopyable_ability?
        next if pkmn_battler && pkmn_battler.abilities.include?(abil_id)
        next if abilis_pool.include?(abil_id)
        abilis_pool.push(abil_id)
      end
    end
    abilis_pool.sample
  end

  # 应用正态分布获取随机数
  def self.gaussian(mean, standard_deviation)
    loop do
      z = Math.sqrt(-2.0 * Math.log(rand)) * Math.cos(2.0 * Math::PI * rand)
      random_number = mean + standard_deviation * z
      if random_number >= mean - standard_deviation && random_number <= mean + standard_deviation
        return random_number.round
      end
    end
  end

  # 导出技能的动画列表
  def self.export_move_anim_list
    list = pbLoadBattleAnimations
    all_entries = ""
    list.each_with_index { |entry, index| all_entries += "#{index} #{entry.name}\r\n" }
    Dir.mkdir("PBS") rescue nil
    file = File.open("PBS/move_anim_list.txt", "wb")
    file.write(all_entries)
    file.close
  end

  # 导出Script的代码到txt
  def self.write_all_scripts_in_txt
    path = "Outputs/"
    Dir.mkdir(path) rescue nil

    file = File.open("Data/Scripts.rxdata")
    essentials_scripts = Marshal.load(file)
    file.close

    File.open("#{path}Essentials_Scripts.txt", "wb") { |file|
      essentials_scripts.each do |script|
        file.write("#{bigline}\n")
        file.write("# Script Page: #{script[1]}\n")
        file.write("#{bigline}\n")
        code = Zlib::Inflate.inflate(script[2]).force_encoding(Encoding::UTF_8)
        file.write("#{code.gsub("\t", "    ")}\n\n")
      end
    }
  end

  # 导出Plugin的代码到txt
  def self.write_all_plugins_in_txt(encrypted = false)
    path = "Outputs/"
    Dir.mkdir(path) rescue nil

    if encrypted
      encrypted_data = File.read("Data/PluginScripts.rxdata")
      plugin_scripts = Marshal.restore(Zlib::Inflate.inflate(encrypted_data.unpack("m")[0]))
    else
      plugin_scripts = load_data("Data/PluginScripts.rxdata")
    end

    File.open("#{path}Plugin_Scripts.txt", "wb") { |file|
      plugin_scripts.each do |plugin|
        plugin_name = plugin[0]
        scripts = plugin[2]
        scripts.each do |script|
          script_path = script[0]
          file.write("#{bigline}\n")
          file.write("# Plugin Page: #{plugin_name}/#{script_path}\n")
          file.write("#{bigline}\n")
          code = Zlib::Inflate.inflate(script[1]).force_encoding(Encoding::UTF_8)
          file.write("#{code.gsub("\t", "    ")}\n\n")
        end
      end
    }
  end

  @@plugin_counter = 1
  @@script_counter = 1

  # 导出Plugin的代码
  def self.write_all_plugins(encrypted = false)
    path = "Outputs/"
    Dir.mkdir(path) rescue nil
    
    if encrypted
      encrypted_data = File.read("Data/PluginScripts.rxdata")
      plugin_scripts = Marshal.restore(Zlib::Inflate.inflate(encrypted_data.unpack("m")[0]))
    else
      plugin_scripts = load_data("Data/PluginScripts.rxdata")
    end

    plugin_scripts.each do |plugin|
      plugin_name = plugin[0].gsub("/", "_").gsub(":", "_").gsub("：", "_").gsub(" ", "_")
      folder_name = sprintf("%s%03d_%s", path, @@plugin_counter, plugin_name)
      Dir.mkdir(folder_name) rescue nil

      scripts = plugin[2]
      scripts.each do |script|
        file_name = script[0].gsub("\\", "/").split("/")[-1].gsub(".rb", "").gsub(" ", "_")
        file_path = sprintf("%s/%03d_%s.rb", folder_name, @@script_counter, file_name)
        code = Zlib::Inflate.inflate(script[1]).force_encoding(Encoding::UTF_8)
        File.open(file_path, "wb") { |file| file.write("#{code.gsub("\t", "    ")}") }
        @@script_counter += 1 
      end
      @@plugin_counter += 1
    end
    @@plugin_counter = 1
    @@script_counter = 1
  end

  def self.pbsline
    "#-------------------------------"
  end

  def self.bigline
    "#==============================================================================="
  end

  # 快速获取颜色
  def self.get_color(key = :BLACK, opacity = 255)
    color = {
      # Grayscale
      :COOL_BLACK => [ 57,  69,  81],
      :BLACK      => [  0,   0,   0],
      :DARK_GRAY  => [ 63,  63,  63],
      :GRAY       => [127, 127, 127],
      :LIGHT_GRAY => [191, 191, 191],
      :WHITE      => [255, 255, 255],
      :COOL_WHITE => [206, 206, 206],
      # Reds
      :RED         => [255,   0,   0],
      :COOL_RED    => [255,  63,  63],
      :PASTEL_RED  => [255, 127, 127],
      :PINK        => [255, 191, 191],
      :ROSE        => [255,   0, 110],
      :COOL_ROSE   => [255,  63, 146],
      :PASTEL_ROSE => [255, 127, 182],
      :SKIN_TONE   => [255, 191, 218],
      :BURGUNDY    => [127,   0,   0],
      # Oranges/Browns
      :ORANGE        => [255, 106,   0],
      :COOL_ORANGE   => [255, 140,  63],
      :PASTEL_ORANGE => [255, 178, 127],
      :PEACH         => [255, 216, 191],
      :BROWN         => [127,  51,   0],
      :COOL_BROWN    => [124,  68,  31],
      :PASTEL_BROWN  => [124,  87,  62],
      :MUD           => [124, 106,  93],
      # Yellow
      :YELLOW        => [255, 216,   0],
      :COOL_YELLOW   => [255, 223,  63],
      :PASTEL_YELLOW => [255, 233, 127],
      :APRICOT       => [255, 244, 191],
      # Greens
      :GREEN        => [  0, 127,   0],
      :COOL_GREEN   => [ 31, 124,  40],
      :SPRUCE       => [ 62, 124,  68],
      :DEEP_SPRUCE  => [ 93, 124,  96],
      :LIME_GREEN   => [182, 255,   0],
      :PASTEL_LIME  => [218, 255, 127],
      :LIGHT_GREEN  => [  0, 255,   0],
      :PASTEL_GREEN => [165, 255, 127],
      # Teals/Cyans
      :TEAL        => [  0, 255, 124],
      :COOL_TEAL   => [ 63, 255, 168],
      :PASTEL_TEAL => [127, 255, 197],
      :SNOW        => [191, 255, 226],
      :CYAN        => [  0, 255, 255],
      :COOL_CYAN   => [ 63, 255, 255],
      :PASTEL_CYAN => [127, 255, 255],
      :ICE         => [191, 255, 255],
      # Blues
      :MARINE        => [  0, 148, 255],
      :COOL_MARINE   => [ 63, 175, 255],
      :PASTEL_MARINE => [127, 201, 255],
      :CLOUD         => [191, 228, 255],
      :BLUE          => [  0,   0, 255],
      :COOL_BLUE     => [ 63,  63, 255],
      :PASTEL_BLUE   => [127, 127, 255],
      :LAVENDER      => [191, 191, 255],
      :INDIGO        => [ 72,   0, 255],
      :COOL_INDIGO   => [114,  63, 255],
      :PASTEL_INDIGO => [161, 127, 255],
      :LILAC         => [207, 191, 255],
      # Purples
      :PURPLE         => [178,   0, 255],
      :COOL_PURPLE    => [194,  63, 255],
      :PASTEL_PURPLE  => [214, 127, 255],
      :BURDOCK        => [234, 191, 255],
      :MAGENTA        => [255,   0, 255],
      :COOL_MAGENTA   => [255,  63, 255],
      :PASTEL_MAGENTA => [255, 127, 255],
      :PUCE           => [204, 136, 153],
      # Custom
    }
    col = color[key.upcase.to_sym] || color[:BLACK]
    Color.new(*col, opacity)
  end
end