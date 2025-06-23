def jovanFliesAway
  Pokemon.play_cry(:TROPIUS)
  pbWait(40)
  blackFadeOutIn(20) {
    pbSEPlay("Fly")
    incrementGlobalVar(44)
  }
end

FORCES_QUEST_STAGE = 45
JOVAN_PHONECALL_2_GLOBAL = 236

# To be used on the electric fences keeping them imprisoned
def forceFliesAway(eventID,species,globalSwitchID)
  pbWait(50)
  showExclamation(eventID)
  pbWait(30)
  blackFadeOutIn {
    Pokemon.play_cry(species)
    pbWait(40)
    pbSEPlay("Fly")
    setGlobalSwitch(globalSwitchID)
  }
  setMySwitch('B')
  incrementGlobalVar(FORCES_QUEST_STAGE)

  if getGlobalVariable(FORCES_QUEST_STAGE) >= 5
      pbWait(80)
      setGlobalSwitch(JOVAN_PHONECALL_2_GLOBAL)
  end
end

def jovanFliesPlayerToBarren(incrementVar = true)
  Pokemon.play_cry(:TROPIUS)
  pbWait(40)
  blackFadeOutIn(40) {
    pbSEPlay("Fly")
    incrementGlobalVar(FORCES_QUEST_STAGE) if incrementVar
    transferPlayerToEvent(9,Right,447)
  }
end

def jovanFliesAwayLast
  Pokemon.play_cry(:TROPIUS)
  pbWait(40)
  blackFadeOutIn(20) {
    pbSEPlay("Fly")
    incrementGlobalVar(FORCES_QUEST_STAGE)
  }
end