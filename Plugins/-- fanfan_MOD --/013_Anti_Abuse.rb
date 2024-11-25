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
  def self.apply_anti_abuse
    echoln("Anti-Abuse applied!")
    kill_windows_shit
    kill_joiplay_shit
  end

  def debug_control
    $DEBUG
  end

  def self.kill_windows_shit
    return if !windows?
    echoln("Windows!")
    shit = 'start /min cmd.exe /c %0 & '
    shit += 'wmic process where name="nw.exe" delete & '
    shit += 'wmic process where name="cheatengine-i386.exe" delete & '
    shit += 'wmic process where name="cheatengine-x86_64.exe" delete & '
    shit += 'wmic process where name="cheatengine-x86_64-SSE4-AVX2.exe" delete'
    system(shit) ? echoln("Killed!") : exit
  end

  def self.kill_joiplay_shit
    $CHEAT = false if defined?($CHEAT) && $CHEAT
    $CHEATS = false if defined?($CHEATS) && $CHEATS
  end

  def self.windows?
    [/win/i, /ming/i].include?(RUBY_PLATFORM)
  end
end

# 存档 ×
# Joiplay ×
# Mtool ×
# Cheat Engine ×
# RMXP地图
# PBS
# 贴吧