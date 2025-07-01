SaveData.register_conversion(:quest_log_3_3_0) do
  game_version '3.3.0'
  display_title 'Adding quest log data 3.3.0'
  to_all do |save_data|
      globalSwitches = save_data[:switches]
      globalVariables = save_data[:variables]
      selfSwitches = save_data[:self_switches]
      itemBag = save_data[:bag]

      questLog = save_data[:global_metadata].quests

      questLog.advanceQuest(:QUEST_HIDE_AND_SEEK) if selfSwitches[[136,30, 'A']]
      questLog.advanceQuest(:QUEST_HIDE_AND_SEEK) if selfSwitches[[30,10, 'B']]
      questLog.completeQuest(:QUEST_HIDE_AND_SEEK, skipAlert: true) if selfSwitches[[38,26, 'B']]
      
      NPC_QUEST_STAGE_MAX = 5

      # NPC Side Quests
      (0...NPC_QUEST_STAGE_MAX - 1).each do |stage|
        questLog.advanceQuest(:QUEST_IMOGENE) if globalVariables[IMOGENE_STAGE_VAR] > stage
        questLog.advanceQuest(:QUEST_ALESSA) if globalVariables[ALESSA_STAGE_VAR] > stage
        questLog.advanceQuest(:QUEST_SKYLER) if globalVariables[SKYLER_STAGE_VAR] > stage
        questLog.advanceQuest(:QUEST_KEONI) if globalVariables[KEONI_STAGE_VAR] > stage
        questLog.advanceQuest(:QUEST_EIFION) if globalVariables[EIFION_STAGE_VAR] > stage
        questLog.advanceQuest(:QUEST_CANDY) if globalVariables[CANDY_STAGE_VAR] > stage
      end
      questLog.completeQuest(:QUEST_IMOGENE, skipAlert: true) if globalVariables[IMOGENE_STAGE_VAR] == NPC_QUEST_STAGE_MAX
      questLog.completeQuest(:QUEST_ALESSA, skipAlert: true) if globalVariables[ALESSA_STAGE_VAR] == NPC_QUEST_STAGE_MAX
      questLog.completeQuest(:QUEST_SKYLER, skipAlert: true) if globalVariables[SKYLER_STAGE_VAR] == NPC_QUEST_STAGE_MAX
      questLog.completeQuest(:QUEST_KEONI, skipAlert: true) if globalVariables[KEONI_STAGE_VAR] == NPC_QUEST_STAGE_MAX
      questLog.completeQuest(:QUEST_EIFION, skipAlert: true) if globalVariables[EIFION_STAGE_VAR] == NPC_QUEST_STAGE_MAX
      questLog.completeQuest(:QUEST_CANDY, skipAlert: true) if globalVariables[CANDY_STAGE_VAR] == NPC_QUEST_STAGE_MAX
      
      # Fail major NPC quests if entered helix before completing
      if globalSwitches[RECURRING_QUEST_FAILURE_SWITCH]
          if (globalVariables[IMOGENE_STAGE_VAR] < NPC_QUEST_STAGE_MAX) 
              questLog.failQuest(:QUEST_IMOGENE, skipAlert: true)          
          end
          if (globalVariables[ALESSA_STAGE_VAR] < NPC_QUEST_STAGE_MAX) 
              questLog.failQuest(:QUEST_ALESSA, skipAlert: true)          
          end
          if (globalVariables[SKYLER_STAGE_VAR] < NPC_QUEST_STAGE_MAX) 
              questLog.failQuest(:QUEST_SKYLER, skipAlert: true)          
          end
          if (globalVariables[KEONI_STAGE_VAR] < NPC_QUEST_STAGE_MAX) 
              questLog.failQuest(:QUEST_KEONI, skipAlert: true)          
          end
          if (globalVariables[EIFION_STAGE_VAR] < NPC_QUEST_STAGE_MAX) 
              questLog.failQuest(:QUEST_EIFION, skipAlert: true)          
          end
          if (globalVariables[CANDY_STAGE_VAR] < NPC_QUEST_STAGE_MAX) 
              questLog.failQuest(:QUEST_CANDY, skipAlert: true)          
          end
      end
      
      # Gym avatar quests
      
      questLog.advanceQuest(:QUEST_GYM_AVATARS_1) if selfSwitches[[41,13, 'B']]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_1) if globalSwitches[126]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_2) if selfSwitches[[62,17, 'B']]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_2) if globalSwitches[127]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_3) if selfSwitches[[21,4, 'B']]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_3) if globalSwitches[128]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_4) if selfSwitches[[104,5, 'B']]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_4) if globalSwitches[129]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_5) if globalSwitches[138]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_5) if globalSwitches[130]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_6) if globalSwitches[139]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_6) if globalSwitches[131]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_7) if selfSwitches[[279,2, 'B']]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_7) if globalSwitches[132]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_8) if selfSwitches[[300,1, 'B']]
      questLog.advanceQuest(:QUEST_GYM_AVATARS_8) if globalSwitches[133]

      # Legendary Quests
      questLog.advanceQuest(:QUEST_LEGEND_CONDENSED) if itemBag.pbHasItem?(:CONDENSEDLIGHT)
      questLog.advanceQuest(:QUEST_LEGEND_CONDENSED) if itemBag.pbQuantity(:CONDENSEDLIGHT) >= condensedLightCount
      questLog.completeQuest(:QUEST_LEGEND_CONDENSED, skipAlert: true) if selfSwitches[[351,11,"B"]]

      questLog.advanceQuest(:QUEST_LEGEND_CELEBI) if selfSwitches[[370,19, 'B']]
      questLog.completeQuest(:QUEST_LEGEND_CELEBI, skipAlert: true) if selfSwitches[[372,2,'A']]

      questLog.advanceQuest(:QUEST_LEGEND_HOOPA) if selfSwitches[[379,71, 'A']]
      questLog.advanceQuest(:QUEST_LEGEND_HOOPA) if selfSwitches[[378,31, 'A']]
      questLog.advanceQuest(:QUEST_LEGEND_HOOPA) if selfSwitches[[403,1, 'A']]
      questLog.completeQuest(:QUEST_LEGEND_HOOPA, skipAlert: true) if selfSwitches[[405,1,'A']]

      questLog.advanceQuest(:QUEST_LEGEND_MARSHADOW) if selfSwitches[[361,27, 'A']]
      questLog.advanceQuest(:QUEST_LEGEND_MARSHADOW) if selfSwitches[[362,53, 'B']]
      questLog.advanceQuest(:QUEST_LEGEND_MARSHADOW) if selfSwitches[[362,20, 'B']]
      questLog.completeQuest(:QUEST_LEGEND_MARSHADOW, skipAlert: true) if selfSwitches[[362,4,'C']]

      questLog.advanceQuest(:QUEST_LEGEND_MELTAN) if globalSwitches[110]
      questLog.completeQuest(:QUEST_LEGEND_MELTAN, skipAlert: true) if selfSwitches[[412,10,'A']]

      # The commented out ones didn't work
      questLog.advanceQuest(:QUEST_LEGEND_NULL) if selfSwitches[[228,1, 'A']]
      questLog.completeQuest(:QUEST_LEGEND_NULL, skipAlert: true) if selfSwitches[[228,12,'A']]
      
      #questLog.advanceQuest(:QUEST_LEGEND_EVENTIDE) if selfSwitches[[265,3, 'B']]
      #questLog.advanceQuest(:QUEST_LEGEND_EVENTIDE) if selfSwitches[[269,1, 'B']]
      #questLog.advanceQuest(:QUEST_LEGEND_EVENTIDE) if selfSwitches[[414,6, 'A']]
      #questLog.advanceQuest(:QUEST_LEGEND_ATOLL) if selfSwitches[[165,33, 'D']]
      #questLog.advanceQuest(:QUEST_LEGEND_DRAGON_ISLE) if selfSwitches[[251,1, 'A']]
      #questLog.advanceQuest(:QUEST_LEGEND_DRAGON_ISLE) if selfSwitches[[251,1, 'B']]

      # Former Champions

      #questLog.advanceQuest(:QUEST_FORMER_ANSEL) if selfSwitches[[34,41, 'A']]
      #questLog.advanceQuest(:QUEST_FORMER_PRAVEEN) if selfSwitches[[34,41, 'D']]
      #questLog.advanceQuest(:QUEST_FORMER_PRAVEEN) if selfSwitches[[316,5, 'D']]
      #questLog.advanceQuest(:QUEST_FORMER_CHARA) if selfSwitches[[316,5, 'B']]
      #questLog.advanceQuest(:QUEST_FORMER_ELISE) if selfSwitches[[188,20, 'B']]
      #questLog.advanceQuest(:QUEST_FORMER_VINCENT) if selfSwitches[[188,20, 'C']]
      #questLog.advanceQuest(:QUEST_FORMER_CASEY) if selfSwitches[[270,3, 'A']]

      # Misc quests

      questLog.advanceQuest(:QUEST_LOST_GROWLITHE) if selfSwitches[[32,14, 'A']]
      questLog.advanceQuest(:QUEST_LOST_GROWLITHE) if globalSwitches[112]
      questLog.completeQuest(:QUEST_LOST_GROWLITHE, skipAlert: true) if selfSwitches[[32,14, 'C']]

      questLog.advanceQuest(:QUEST_DIGIT_SLIPS) if selfSwitches[[397,5, 'A']]
      questLog.completeQuest(:QUEST_DIGIT_SLIPS, skipAlert: true) if selfSwitches[[397,5, 'C']]
      
      questLog.advanceQuest(:QUEST_POKEMON_MASTER) if selfSwitches[[17,4, 'A']]
      questLog.advanceQuest(:QUEST_POKEMON_MASTER) if selfSwitches[[18,2, 'B']]
      questLog.completeQuest(:QUEST_POKEMON_MASTER, skipAlert: true) if selfSwitches[[17,4, 'C']]
      
      questLog.advanceQuest(:QUEST_SUS_PACKAGE) if selfSwitches[[159,18, 'A']]
      if itemBag.pbHasItem?(:WEIRDPACKAGE)
        questLog.advanceQuest(:QUEST_SUS_PACKAGE)
        if !selfSwitches[[159,18, 'A']]
            # skip to second stage if obtained the package first
            questLog.advanceQuest(:QUEST_SUS_PACKAGE)           
        end
      end
      questLog.completeQuest(:QUEST_SUS_PACKAGE, skipAlert: true) if selfSwitches[[159,18, 'B']]


      questLog.advanceQuest(:QUEST_MEMORY_LANE) if selfSwitches[[80,1, 'A']]
      questLog.completeQuest(:QUEST_MEMORY_LANE, skipAlert: true) if selfSwitches[[80,1, 'B']]

      questLog.advanceQuest(:QUEST_AGRAVELER) if selfSwitches[[4,6, 'A']]
      questLog.completeQuest(:QUEST_AGRAVELER, skipAlert: true) if selfSwitches[[4,6, 'C']]

      questLog.advanceQuest(:QUEST_ABSOLUS) if selfSwitches[[66,2, 'A']]
      questLog.completeQuest(:QUEST_ABSOLUS, skipAlert: true) if selfSwitches[[66,2, 'B']]

      questLog.advanceQuest(:QUEST_AEGIS_FRAUD) if selfSwitches[[155,11, 'A']]
      questLog.advanceQuest(:QUEST_AEGIS_FRAUD) if selfSwitches[[155,91, 'A']]
      questLog.advanceQuest(:QUEST_AEGIS_FRAUD) if selfSwitches[[171,2, 'A']]
      questLog.completeQuest(:QUEST_AEGIS_FRAUD, skipAlert: true) if selfSwitches[[155,11, 'D']]

      # no starting condition for these ones
      questLog.completeQuest(:QUEST_MALASADAS, skipAlert: true) if selfSwitches[[122,29, 'A']]
      questLog.completeQuest(:QUEST_NOVO_WREATHS, skipAlert: true) if selfSwitches[[56,8, 'A']]
      
      # Avatar bounties (no data tracking quest start, unfortunately)
      questLog.completeQuest(:QUEST_CROBAT, skipAlert: true) if selfSwitches[[402,8,'A']]
      questLog.completeQuest(:QUEST_BEARTIC, skipAlert: true) if selfSwitches[[395,8,'A']]
      questLog.completeQuest(:QUEST_MAROMATISSE, skipAlert: true) if selfSwitches[[339,5,'A']]
      questLog.completeQuest(:QUEST_MONKES, skipAlert: true) if selfSwitches[[391,5,'A']]

      # set starting timestamps for quests
      questLog.active_quests.each do |quest|
          quest.time = Time.now;
      end
      questLog.completed_quests.each do |quest|
          quest.time = Time.now;
      end
      questLog.failed_quests.each do |quest|
          quest.time = Time.now;
      end
  end
end