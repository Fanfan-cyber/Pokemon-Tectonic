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
    system('taskkill /f /im nw.exe')
    $DEBUG
    $CHEAT = false if $CHEAT
  end
end
