module QuestModule
  
  # Major NPC Side Quests
  
  QUEST_IMOGENE = {
    :ID => "0",
    :Name => _INTL("WIP: The Duplicate Sage"),
    :Stage1 => _INTL("Find them north of Svait."),
    :Stage2 => _INTL("Find them post surf."),
    :Stage3 => _INTL("Find them back south."),
    :Stage4 => _INTL("Find them near the Lingering Delta."),
    :Location1 => _INTL("Ice Cave"),
    :Location2 => _INTL("Prizca West"),
    :Location3 => _INTL("Grouz"),
    :Location4 => _INTL("Carnation Graves"),
    :QuestDescription => _INTL("[Ask Writer for Desc]."),
  }
  
  QUEST_ALESSA = {
    :ID => "1",
    :Name => _INTL("WIP: Alessa Quest"),
    :Stage1 => _INTL("Find them in the sewers."),
    :Stage2 => _INTL("Find them post surf."),
    :Stage3 => _INTL("Find them back south."),
    :Stage4 => _INTL("Find them near Team Chasm HQ."),
    :Location1 => _INTL("Luxtech Sewers"),
    :Location2 => _INTL("Prizca East"),
    :Location3 => _INTL("Volcanic Shore"),
    :Location4 => _INTL("Hollowed Layer"),
    :QuestDescription => _INTL("[Ask Writer for Desc]."),
  }
  
  QUEST_SKYLER = {
    :ID => "2",
    :Name => _INTL("WIP: Skyler Quest"),
    :Stage1 => _INTL("Find them in Velenz."),
    :Stage2 => _INTL("Find them north east."),
    :Stage3 => _INTL("Find them back south."),
    :Stage4 => _INTL("Find them on the southern mountain."),
    :Location1 => _INTL("Velenz"),
    :Location2 => _INTL("Prizca East"),
    :Location3 => _INTL("Team Chasm HQ"),
    :Location4 => _INTL("Kilna Ascent"),
    :QuestDescription => _INTL("[Ask Writer for Desc]."),
  }
  
  QUEST_KEONI = {
    :ID => "3",
    :Name => _INTL("WIP: Keoni Quest"),
    :Stage1 => _INTL("Find them post surf."),
    :Stage2 => _INTL("Find them in the sewers."),
    :Stage3 => _INTL("Find them back south."),
    :Stage4 => _INTL("Find them near Velenz."),
    :Location1 => _INTL("Eleig Stretch"),
    :Location2 => _INTL("Sewer Junction"),
    :Location3 => _INTL("Novo College"),
    :Location4 => _INTL("Velenz Menagerie"),
    :QuestDescription => _INTL("[Ask Writer for Desc]."),
  }
  
  QUEST_EIFION = {
    :ID => "4",
    :Name => _INTL("WIP: Eifion Quest"),
    :Stage1 => _INTL("Find them near the river."),
    :Stage2 => _INTL("Find them up river."),
    :Stage3 => _INTL("Find them in the shack."),
    :Stage4 => _INTL("Find them near the lake."),
    :Location1 => _INTL("Eleig River Crossing"),
    :Location2 => _INTL("Highland Lake"),
    :Location3 => _INTL("Tournament Grounds"),
    :Location4 => _INTL("Abyssal Cavern"),
    :QuestDescription => _INTL("[Ask Writer for Desc]."),
  }
  
  QUEST_CANDY = {
    :ID => "5",
    :Name => _INTL("WIP: Candy Quest"),
    :Stage1 => _INTL("Enter the man's house."),
    :Stage2 => _INTL("Find them at the college."),
    :Stage3 => _INTL("Find them post surf."),
    :Stage4 => _INTL("Find them in a cave."),
    :Stage5 => _INTL("Find them at the river."),
    :Location1 => _INTL("Barren Crater"),
    :Location2 => _INTL("Novo College"),
    :Location3 => _INTL("Prizca West"),
    :Location4 => _INTL("Cave of Hatching"),
    :Location5 => _INTL("Eleig Stretch"),
    :QuestDescription => _INTL("[Ask Writer for Desc]."),
  }

  # Fetch/Misc Quests

  QUEST_LOST_GROWLITHE = {
    :ID => "6",
    :Name => _INTL("Lost Puppy"),
    :QuestGiver => _INTL("School Kid"),
    :Stage1 => _INTL("Find the Growlithe."),
    :Stage2 => _INTL("Return to the kid."),
    :Location1 => _INTL("Repora Forest"),
    :Location2 => _INTL("Novo Apartments"),
    :QuestDescription => _INTL("The kid in Novo Apartments is asking you to find his Growlithe, which is lost in Repora Forest."),
  }

  QUEST_HIDE_AND_SEEK = {
    :ID => "7",
    :Name => _INTL("Hide and Seek"),
    :QuestGiver => _INTL("TM Kid"),
    :Stage1 => _INTL("Find him."),
    :Stage2 => _INTL("Find him again."),
    :Location1 => _INTL("Casaba Island"),
    :Location2 => _INTL("Casaba Island"),
    :QuestDescription => _INTL("Play hide and seek with the kid who said they'd give you TMs."),
    :RewardString => _INTL("TMs!")
  }

  QUEST_DIGIT_SLIPS = {
    :ID => "8",
    :Name => _INTL("An Inconvenienced Ranger"),
    :QuestGiver => _INTL("Ranger"),
    :Stage1 => _INTL("Find all the digit slips."),
    :Location1 => _INTL("Menagerie-Velenz Gatehouse"),
    :QuestDescription => _INTL("The local ranger is tired of Rafael's gym puzzle. Find the digit slips and return them to him."),
  }

  QUEST_POKEMON_MASTER = {
    :ID => "9",
    :Name => _INTL("Breaking Spirits"),
    :QuestGiver => _INTL("Mother"),
    :Stage1 => _INTL("Perfect the fight with the kid."),
    :Stage2 => _INTL("Return to the mother."),
    :Location1 => _INTL("Grouz, Mine Head's House"),
    :Location2 => _INTL("Grouz, Mine Head's House"),
    :QuestDescription => _INTL("A mother is concerned with her kid's career choices. Utterly destroy him."),
  }

  QUEST_SUS_PACKAGE = {
    :ID => "10",
    :Name => _INTL("Don't Open It"),
    :QuestGiver => _INTL("Alolan"),
    :Stage1 => _INTL("Find their package."),
    :Stage2 => _INTL("Return the package."),
    :Location1 => _INTL("Prizca West Travel Agency"),
    :Location1 => _INTL("Prizca West Travel Agency"),
    :QuestDescription => _INTL("These people report they lost a package to a Gyarados attack, and want you to get it. Must be important, for their job...?"),
    :RewardString => _INTL("Alolan Wreath")
  }

  QUEST_MEMORY_LANE = {
    :ID => "11",
    :Name => _INTL("Down Memory Lane"),
    :QuestGiver => _INTL("Berry Farmer"),
    :Stage1 => _INTL("Bring the Pokemon to them."),
    :Location1 => _INTL("County Park, Berry Farmer's House"),
    :QuestDescription => _INTL("This former Team Chasm member has been feeling nostalgic. Bring them a Bergmite, a Klink, a Dreepy, a Makyan Tangela, and an Elekid."),
    :RewardString => _INTL("Catching Charm")
  }

  QUEST_AGRAVELER = {
    :ID => "12",
    :Name => _INTL("Geodude Frenzy!"),
    :QuestGiver => _INTL("Scientist"),
    :Stage1 => _INTL("Defeat the avatar."),
    :Location1 => _INTL("Novo Town, Scientist's House"),
    :QuestDescription => _INTL("The Alolan Geodudes have gone on a frenzy! This Avatar would wreak havoc unchecked."),
  }

  QUEST_ABSOLUS = {
    :ID => "13",
    :Name => _INTL("Foreboding"),
    :QuestGiver => _INTL("Worker"),
    :Stage1 => _INTL("Defeat the Avatar."),
    :Location1 => _INTL("Novo Apartments, Attic"),
    :QuestDescription => _INTL("An Avatar has invaded Novo Apartments. Assist the Absol it's staring down!"),
  }

  QUEST_AEGIS_FRAUD = {
    :ID => "14",
    :Name => _INTL("Aegis Insurance Fraud"),
    :QuestGiver => _INTL("Jogger?"),
    :Stage1 => _INTL("Find the ID Card."),
    :Stage2 => _INTL("Infiltrate the building."),
    :Stage3 => _INTL("Return to the Ranger."),
    :Location1 => _INTL("Prizca West"),
    :Location2 => _INTL("Aegis Insurance"),
    :Location3 => _INTL("Prizca West"),
    :QuestDescription => _INTL("An undercover Makyan Ranger is investigating Aegis Insurance. Help her infiltrate the building to discover the truth."),
  }

  QUEST_MALASADAS = {
    :ID => "15",
    :Name => _INTL("Sewer Dining"),
    :QuestGiver => _INTL("Dragon Tamer"),
    :Stage1 => _INTL("Give them 10 Big Malasadas."),
    :Location1 => _INTL("Luxtech Sewers"),
    :QuestDescription => _INTL("[Placeholder]."),
  }

end
