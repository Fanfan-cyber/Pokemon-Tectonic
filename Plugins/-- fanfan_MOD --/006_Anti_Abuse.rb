module SaveData
  def self.get_data_from_file(file_path)
    validate file_path => String
    encrypted_data = File.read(file_path)
    Marshal.restore(Zlib::Inflate.inflate(encrypted_data.unpack("m")[0]))
  end

  def self.save_to_file(file_path)
    validate file_path => String
    save_data = self.compile_save_hash
    encrypted_data = [Zlib::Deflate.deflate(Marshal.dump(save_data))].pack("m")
    File.open(file_path, "wb") { |file| file.write(encrypted_data) }
  end
end

module AntiAbuse
  DEBUG_PASSWORD  = "12138"
  GAME_OFFICIAL   = %w[宝可饭堂 pokefans 地震啦！！！ 493645591]
  OFFICIAL_SITE   = "https://bbs.pokefans.xyz/threads/598/"
  CHEAT_CLASS     = [:CheatItemsAdapter, :ScreenCheat_Items, :SceneCheat_Items, :Scene_Cheat, :Window_GetItem, :PokemonLoad]
  CHEAT_METHOD    = [:pbenabledebug, :pbDebugMenu]
  CHEAT_PROCESS   = %w[nw.exe cheatengine-i386.exe cheatengine-x86_64.exe cheatengine-x86_64-SSE4-AVX2.exe]
  @@debug_control = false

  def self.apply_anti_abuse
    kill_windows_shit
    kill_joiplay_shit
    debug_check
  end

  def self.debug_check
    return if !$DEBUG || @@debug_control
    password = pbEnterText(_INTL("Enter Debug Password."), 0, 32)
    exit if password != DEBUG_PASSWORD
    @@debug_control = true
  end

  def self.check_claim
    if pbConfirmMessageSerious(_INTL("Did you download the game from the official source?"))
      pbMessage(_INTL("Please enter the forum where you downloaded the game. (Website or QQ group)"))
      forum = pbEnterText(_INTL("Enter the right source."), 0, 32)
      exit if !GAME_OFFICIAL.include?(forum)
      return
    end
    System.launch(OFFICIAL_SITE) if pbConfirmMessage(_INTL("Would you like to re-download the game from the official source?"))
    exit
  end

  def self.kill_windows_shit
    return if !windows?
    CHEAT_PROCESS.each do |process|
      next if !process_exists?(process)
      exit if !system("taskkill /F /IM #{process}")
    end
  end

  def self.process_exists?(process_name)
    result = `tasklist /FI "IMAGENAME eq #{process_name}" /FO CSV /NH`
    result.include?(process_name)
  end

  def self.kill_joiplay_shit
    $CHEAT  = false
    $CHEATS = false
  end

  def self.kill_all_cheats
    rewrite_cheat_method
    CHEAT_CLASS.each { |klass| kill_cheat_klass(klass) }
    $wtw = false
  end

  def self.kill_cheat_klass(klass_name)
    return if !Object.const_defined?(klass_name)
    Object.send(:remove_const, klass_name)
  end

  def self.rewrite_cheat_method
    CHEAT_CLASS.each do |klass_name|
      next if !Object.const_defined?(klass_name)
      klass = Object.const_get(klass_name)
      klass.define_method(:initialize) { exit }
    end
    CHEAT_METHOD.each { |method| define_method(method) { exit } }
  end

  def self.windows?
    [/win/i, /mingw/i, /mswin/i].any? { |regex| regex.match?(RUBY_PLATFORM) }
  end
end