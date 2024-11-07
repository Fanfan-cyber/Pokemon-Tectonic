CHANGE_LOG = <<-LOGGER
#==============================================================================#
Pokémon Tectonic: Earthquake
by Fanfan
v0.0.1 
#==============================================================================#
以下部分记录了此游戏相对于官方游戏的所有更改，
但是只会记录可能会影响到玩家的更改，
一些内部的和玩家无关的代码整理优化等，
则不会记录在内。
#==============================================================================#
v0.0.1
1.同步官方更新，每一次更新时都会同步官方更新，后续将不再单独列出
2.
LOGGER

CHANGE_LOG.gsub!("\n", "\r\n")

file = File.open("release_version.txt", "wb")
file.write(Settings::GAME_VERSION)
file.close

file = File.open("release_version_mod.txt", "wb")
file.write(CHANGE_LOG)
file.close