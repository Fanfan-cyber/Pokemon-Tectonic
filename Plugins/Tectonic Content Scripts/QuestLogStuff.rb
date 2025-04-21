# Progresses or ends quests when all of a certain thing is gotten

def completeTriIslandQuest
  if pbGetSelfSwitch(1, 'A', 416) && pbGetSelfSwitch(1, 'A', 417) && pbGetSelfSwitch(1, 'A', 415)
      completeQuest(:QUEST_LEGEND_TRI_ISLAND)
  end
end

def stageThreeCalyrexQuest
  if pbGetSelfSwitch(24, 'A', 333) && pbGetSelfSwitch(1, 'A', 434) && pbGetSelfSwitch(1, 'A', 436)
      advanceQuestToStage(:QUEST_LEGEND_CALYREX2, 3)
  end
end

def completeGuardianIslandQuest
    if pbGetSelfSwitch(2, 'A', 386) && pbGetSelfSwitch(2, 'A', 387) && pbGetSelfSwitch(2, 'A', 388) && pbGetSelfSwitch(2, 'A', 389)
        completeQuest(:QUEST_LEGEND_GUARDIAN_ISLAND)
    end
end

def stageTwoSigiLQuest
    if pbGetSelfSwitch(1, 'A', 135) && pbGetSelfSwitch(7, 'A', 330)
        advanceQuestToStage(:QUEST_LEGEND_SIGIL, 2)
    end
end

def stageTwoFormerChamps
    if pbGetSelfSwitch(41, 'D', 34) && pbGetSelfSwitch(33, 'D', 165) && pbGetSelfSwitch(3, 'D', 270) && pbGetSelfSwitch(3, 'B', 265) && pbGetSelfSwitch(3, 'D', 270) && pbGetSelfSwitch(5, 'D', 316)
        advanceQuestToStage(:QUEST_FORMER_CHAMPIONS, 2)
    end
end

def completeDragonIsleQuest
    if pbGetSelfSwitch(1, 'A', 356) && pbGetSelfSwitch(2, 'A', 356)
        advanceQuestToStage(:QUEST_LEGEND_DRAGON_ISLE)
    end
end

# Ends quest if Lugia is caught

BallHandlers::OnPokemonCaught += proc { |ball, battle, pkmn|
    next unless pkmn.species == :LUGIA
    next unless $game_map.map_id == 239 # ocean fishing contest

    completeQuest(:QUEST_LEGEND_LUGIA)
}