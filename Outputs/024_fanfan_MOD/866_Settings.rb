module Settings
  MOD_VERSION = "0.0.1"

  # Button used for Text Skipping (Default = :X)
  TEXT_SKIP_BUTTON = :V

  # Button used for Fast Forward (Default = :F)
  FAST_FORWARD_KEY = :Q
end

file = File.open("release_version.txt", "wb")
file.write(Settings::GAME_VERSION)
file.close

file = File.open("release_version_mod.txt", "wb")
file.write(Settings::MOD_VERSION)
file.close