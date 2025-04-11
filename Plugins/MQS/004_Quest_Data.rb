module QuestModule
  
  # Major NPC Side Quests
  
  QUEST_IMOGENE = {
    :ID => "0",
    :Name => "WIP: The Duplicate Sage",
    :Stage1 => "Find them north of Svait.",
    :Stage2 => "Find them post surf.",
    :Stage3 => "Find them back south.",
    :Stage4 => "Find them near the Lingering Delta.",
    :Location1 => "Ice Cave",
    :Location2 => "Prizca West",
    :Location3 => "Grouz",
    :Location4 => "Carnation Graves",
    :QuestDescription => "[Ask Writer for Desc].",
  }
  
  QUEST_ALESSA = {
    :ID => "1",
    :Name => "WIP: Alessa Quest",
    :Stage1 => "Find them in the sewers.",
    :Stage2 => "Find them post surf.",
    :Stage3 => "Find them back south.",
    :Stage4 => "Find them near Team Chasm HQ.",
    :Location1 => "Luxtech Sewers",
    :Location2 => "Prizca East",
    :Location3 => "Volcanic Shore",
    :Location4 => "Hollowed Layer",
    :QuestDescription => "[Ask Writer for Desc].",
  }
  
  QUEST_SKYLER = {
    :ID => "2",
    :Name => "WIP: Skyler Quest",
    :Stage1 => "Find them in Velenz.",
    :Stage2 => "Find them north east.",
    :Stage3 => "Find them back south.",
    :Stage4 => "Find them on the southern mountain.",
    :Location1 => "Velenz",
    :Location2 => "Prizca East",
    :Location3 => "Team Chasm HQ",
    :Location4 => "Kilna Ascent",
    :QuestDescription => "[Ask Writer for Desc].",
  }
  
  QUEST_KEONI = {
    :ID => "3",
    :Name => "WIP: Keoni Quest",
    :Stage1 => "Find them post surf.",
    :Stage2 => "Find them in the sewers.",
    :Stage3 => "Find them back south.",
    :Stage4 => "Find them near Velenz.",
    :Location1 => "Eleig Stretch",
    :Location2 => "Sewer Junction",
    :Location3 => "Novo College",
    :Location4 => "Velenz Menagerie",
    :QuestDescription => "[Ask Writer for Desc].",
  }
  
  QUEST_EIFION = {
    :ID => "4",
    :Name => "WIP: Eifion Quest",
    :Stage1 => "Find them near the river.",
    :Stage2 => "Find them up river.",
    :Stage3 => "Find them in the shack.",
    :Stage4 => "Find them near the lake.",
    :Location1 => "Eleig River Crossing",
    :Location2 => "Highland Lake",
    :Location3 => "Tournament Grounds",
    :Location4 => "Abyssal Cavern",
    :QuestDescription => "[Ask Writer for Desc].",
  }
  
  QUEST_CANDY = {
    :ID => "5",
    :Name => "WIP: Candy Quest",
    :Stage1 => "Enter the man's house.",
    :Stage2 => "Find them at the college.",
    :Stage3 => "Find them post surf.",
    :Stage4 => "Find them in a cave.",
    :Stage5 => "Find them at the river.",
    :Location1 => "Barren Crater",
    :Location2 => "Novo College",
    :Location3 => "Prizca West",
    :Location4 => "Cave of Hatching",
    :Location5 => "Eleig Stretch",
    :QuestDescription => "[Ask Writer for Desc].",
  }

  # Fetch/Misc Quests

  QUEST_LOST_GROWLITHE = {
    :ID => "6",
    :Name => "Find Growlithe!",
    :QuestGiver => "School Kid",
    :Stage1 => "Find the Growlithe.",
    :Stage2 => "Return to the kid.",
    :Location1 => "Repora Forest",
    :Location2 => "Novo Apartments",
    :QuestDescription => "The kid in Novo Apartments is asking you to find his Growlithe, which is lost in Repora Forest.",
  }
  
  # Here's an extension of the above that includes multiple stages
  Quest2 = {
    :ID => "2",
    :Name => "Introductions",
    :QuestGiver => "Little Boy",
    :Stage1 => "Look for clues.",
    :Stage2 => "Follow the trail.",
    :Stage3 => "Catch the troublemakers!",
    :Location1 => "Lappet Town",
    :Location2 => "Viridian Forest",
    :Location3 => "Route 3",
    :QuestDescription => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
    :RewardString => "Something shiny!"
  }
  
  # Here's an example of a quest with lots of stages that also doesn't have a stage location defined for every stage
  Quest3 = {
    :ID => "3",
    :Name => "Last-minute chores",
    :QuestGiver => "Grandma",
    :Stage1 => "A",
    :Stage2 => "B",
    :Stage3 => "C",
    :Stage4 => "D",
    :Stage5 => "E",
    :Stage6 => "F",
    :Stage7 => "G",
    :Stage8 => "H",
    :Stage9 => "I",
    :Stage10 => "J",
    :Stage11 => "K",
    :Stage12 => "L",
    :Location1 => "nil",
    :Location2 => "nil",
    :Location3 => "Dewford Town",
    :QuestDescription => "Isn't the alphabet longer than this?",
    :RewardString => "Chicken soup!"
  }
  
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "A new beginning",
    :QuestGiver => "nil",
    :Stage1 => "Turning over a new leaf... literally!",
    :Stage2 => "Help your neighbours.",
    :Location1 => "Milky Way",
    :Location2 => "nil",
    :QuestDescription => "You crash landed on an alien planet. There are other humans here and they look hungry...",
    :RewardString => "nil"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "All of my friends",
    :QuestGiver => "Barry",
    :Stage1 => "Meet your friends near Acuity Lake.",
    :QuestDescription => "Barry told me that he saw something cool at Acuity Lake and that I should go see. I hope it's not another trick.",
    :RewardString => "You win nothing for giving in to peer pressure."
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription => "I'm losing my sanity.",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }

end
