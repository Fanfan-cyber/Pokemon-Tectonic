module TA
  class TA_Vars
    attr_reader :vars

    def initialize
      @vars = {}
    end

    def set(var, value)
      @vars[var] = value
    end

    def get(var)
      @vars[var]
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
        file.write("#{self.bigline}\n")
        file.write("# Script Page: #{script[1]}\n")
        file.write("#{self.bigline}\n")
        code = Zlib::Inflate.inflate(script[2]).force_encoding(Encoding::UTF_8)
        file.write("#{code.gsub("\t", "    ")}\n\n")
      end
    }
  end

  # 导出Plugin的代码到txt
  def self.write_all_plugins_in_txt
    path = "Outputs/"
    Dir.mkdir(path) rescue nil

    plugin_scripts = load_data("Data/PluginScripts.rxdata")

    File.open("#{path}Plugin_Scripts.txt", "wb") { |file|
      plugin_scripts.each do |plugin|
        plugin_name = plugin[0]
        scripts = plugin[2]
        scripts.each do |script|
          script_path = script[0]
          file.write("#{self.bigline}\n")
          file.write("# Plugin Page: #{plugin_name}/#{script_path}\n")
          file.write("#{self.bigline}\n")
          code = Zlib::Inflate.inflate(script[1]).force_encoding(Encoding::UTF_8)
          file.write("#{code.gsub("\t", "    ")}\n\n")
        end
      end
    }
  end

  @@plugin_counter = 1
  @@script_counter = 1

  # 导出Plugin的代码
  def self.write_all_plugins
    path = "Outputs/"
    Dir.mkdir(path) rescue nil
    plugin_scripts = load_data("Data/PluginScripts.rxdata")

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