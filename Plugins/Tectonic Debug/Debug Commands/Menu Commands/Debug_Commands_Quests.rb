DebugMenuCommands.register("beginallquests", {
    "parent"      => "quests",
    "name"        => _INTL("Activate all quests."),
    "description" => _INTL("Activate every quest that is defined in the Quest Data."),
    "always_show" => true,
    "effect"      => proc {
      count =  0
      QuestModule.constants.each do |constant|
        activateQuest(constant.to_sym, skipAlert: true)
        count += 1
      end
      pbMessage(_INTL("Activated {1} quests.",count))
    }
})

DebugMenuCommands.register("activatequest", {
    "parent"      => "quests",
    "name"        => _INTL("Activate a Quest."),
    "description" => _INTL("Activate one of all quests."),
    "always_show" => true,
    "effect"      => proc {
      quest = selectQuestFromList
      activateQuest(quest) if quest
    }
})

DebugMenuCommands.register("advancequest", {
    "parent"      => "quests",
    "name"        => _INTL("Advance a Quest."),
    "description" => _INTL("Advance one of all quests to the next stage."),
    "always_show" => true,
    "effect"      => proc {
      quest = selectQuestFromList
      if quest
        if advanceQuest(quest)
          if completedQuest?(quest)
            pbMessage(_INTL("Quest {1} completed!", $quest_data.getName(quest)))
          else
            pbMessage(_INTL("Quest {1} advanced.", $quest_data.getName(quest)))
          end
        end
      end
    }
})

DebugMenuCommands.register("completequest", {
    "parent"      => "quests",
    "name"        => _INTL("Complete a Quest."),
    "description" => _INTL("Complete one of all quests."),
    "always_show" => true,
    "effect"      => proc {
      quest = selectQuestFromList
      completeQuest(quest) if quest
    }
})

DebugMenuCommands.register("failquest", {
    "parent"      => "quests",
    "name"        => _INTL("Fail a Quest."),
    "description" => _INTL("Fail one of all quests."),
    "always_show" => true,
    "effect"      => proc {
      quest = selectQuestFromList
      failQuest(quest) if quest
    }
})

def selectQuestFromList
  commands = []
  commands.push(_INTL("Cancel"))
  QuestModule.constants.each do |constant|
    commands.push($quest_data.getName(constant))
  end
  cmd = pbMessage(_INTL("Which quest?"),commands)
  return nil if cmd <= 0
  return QuestModule.constants[cmd-1].to_sym
end

DebugMenuCommands.register("resetquestlog", {
    "parent"      => "quests",
    "name"        => _INTL("Reset Quest Log."),
    "description" => _INTL("Remove all quests from the quest log."),
    "always_show" => true,
    "effect"      => proc {
      $PokemonGlobal.quests.reset
      pbMessage(_INTL("Quest Log reset."))
    }
})