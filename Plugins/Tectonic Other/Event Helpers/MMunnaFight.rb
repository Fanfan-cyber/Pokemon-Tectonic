def mmunnaFight(species, level, switch = 'A', form = 0)
  Pokemon.play_cry(species)
  level = [level,getLevelCap].min
  pbWait(30)
  if pbWildBattleCore(species, level) == 4
      fadeSwitchOn(switch)
      return true
  else
      speciesName = GameData::Species.get(species).name
      pbMessage(_INTL("{1} goes back to sleep after being left alone.", speciesName))
      return false
  end
end