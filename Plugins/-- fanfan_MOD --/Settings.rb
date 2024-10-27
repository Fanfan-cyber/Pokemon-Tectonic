module Settings
  MOD_VERSION = "0.0.1"

  ER_MODE = true
  DIETY_Mode = true
end

file = File.open("release_version.txt", "w")
file.write(Settings::GAME_VERSION)
file.close

file = File.open("release_version_mod.txt", "w")
file.write(Settings::MOD_VERSION)
file.close