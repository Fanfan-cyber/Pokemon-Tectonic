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

  @@plugin_counter = 1
  @@script_counter = 1

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
end