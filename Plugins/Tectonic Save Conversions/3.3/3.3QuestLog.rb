SaveData.register_conversion(:quest_log_3_3_0) do
  game_version '3.3.0'
  display_title 'Adding quest log data 3.3.0'
  to_all do |save_data|
      globalSwitches = save_data[:switches]
      globalVariables = save_data[:variables]
      selfSwitches = save_data[:self_switches]
      itemBag = save_data[:bag]

      questLog = save_data[:global_metadata].quests

      questLog.advanceQuest(:QUEST_LEGEND_CONDENSED) if itemBag.pbHasItem?(:CONDENSEDLIGHT)

      questLog.advanceQuest(:QUEST_HIDE_AND_SEEK) if selfSwitches[[136,30, 'A']]
      questLog.advanceQuest(:QUEST_HIDE_AND_SEEK) if selfSwitches[[24,10, 'B']]
      questLog.advanceQuest(:QUEST_HIDE_AND_SEEK) if selfSwitches[[30,26, 'B']]

      questLog.advanceQuest(:QUEST_IMOGENE) if globalVariables[IMOGENE_STAGE_VAR] > 1
      questLog.advanceQuest(:QUEST_ALESSA) if selfSwitches[[56,56, 'A']] || globalVariables[ALESSA_STAGE_VAR] > 1
      questLog.advanceQuest(:QUEST_SKYLER) if globalVariables[SKYLER_STAGE_VAR] > 1
      questLog.advanceQuest(:QUEST_KEONI) if selfSwitches[[20,81, 'A']]
      questLog.advanceQuest(:QUEST_EIFION) if selfSwitches[[40,5,EIFION_STAGE_VAR]]
      questLog.advanceQuest(:QUEST_CANDY) if globalVariables[CANDY_STAGE_VAR] > 1
      
      # TO DO: Fail major NPC quests if entered helix before completing
      
      # Gym avatar quests

      questLog.advanceQuest(:QUEST_LOST_GROWLITHE) if selfSwitches[[32,14, 'A']]
      questLog.advanceQuest(:QUEST_LOST_GROWLITHE) if globalSwitches[112]
      questLog.advanceQuest(:QUEST_DIGIT_SLIPS) if selfSwitches[[397,5, 'A']]
      questLog.advanceQuest(:QUEST_DIGIT_SLIPS) if selfSwitches[[397,5, 'B']]
      questLog.advanceQuest(:QUEST_POKEMON_MASTER) if selfSwitches[[17,4, 'A']]
      questLog.advanceQuest(:QUEST_POKEMON_MASTER) if selfSwitches[[18,2, 'B']]
      questLog.advanceQuest(:QUEST_SUS_PACKAGE) if selfSwitches[[59,18, 'A']]
      questLog.advanceQuest(:QUEST_SUS_PACKAGE) if itemBag.pbHasItem?(:WEIRDPACKAGE)
      questLog.advanceQuest(:QUEST_MEMORY_LANE) if selfSwitches[[80,1, 'A']]
      questLog.advanceQuest(:QUEST_AGRAVELER) if selfSwitches[[4,6, 'A']]
      questLog.advanceQuest(:QUEST_ABSOLUS) if selfSwitches[[66,2, 'A']]
      questLog.advanceQuest(:QUEST_AEGIS_FRAUD) if selfSwitches[[155,11, 'A']]
      questLog.advanceQuest(:QUEST_AEGIS_FRAUD) if selfSwitches[[171,2, 'A']]
      questLog.advanceQuest(:QUEST_AEGIS_FRAUD) if selfSwitches[[155,11, 'D']]
      questLog.advanceQuest(:QUEST_MALASADAS) if selfSwitches[[122,29, 'A']]
      questLog.advanceQuest(:QUEST_NOVO_WREATHS) if selfSwitches[[56,8, 'A']]
      #questLog.advanceQuest(:QUEST_NOVO_WREATHS) if selfSwitches[[TBD,TBD,TBD]]
      
      # Avatar bounties (no data tracking quest start, unfortunately)
      questLog.completeQuest(:QUEST_CROBAT) if selfSwitches[[402,8,'A']]
      questLog.completeQuest(:QUEST_BEARTIC) if selfSwitches[[395,8,'A']]
      questLog.completeQuest(:QUEST_MAROMATISSE) if selfSwitches[[339,5,'A']]
      questLog.completeQuest(:QUEST_MONKES) if selfSwitches[[391,5,'A']]
  end
end