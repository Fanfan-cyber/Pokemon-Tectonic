def apollyonGuidePC
  pbMessage(_INTL("It's open to a battling guide written by someone with the username \"apolLyon.\""))
  sectionChoices = []
  sectionChoices.push(_INTL("1.1 Roles/Cores"))
  sectionChoices.push(_INTL("2.1 Leads"))
  sectionChoices.push(_INTL("3.2 Hazards"))
  sectionChoices.push(_INTL("Exit"))
  loop do
      removeSpeaker
      sectionChoice = pbMessage(_INTL("Which entry would you like to read?"),sectionChoices,sectionChoices.length)
      case sectionChoice
      when 0
          setSpeaker(APOLLYON)
          pbMessage(_INTL("Everything on your team needs a point. Every Pokémon needs a purpose."))
          pbMessage(_INTL("If you can't sum up its role on your team in a sentence, keep it in the PC."))
          pbMessage(_INTL("Every bit of that Pokémon should reinforce its role. Moves, items, everything."))
          pbMessage(_INTL("All six Pokémon on your team need a role, narrow or broad."))
          pbMessage(_INTL("Two Pokémon with synergistic roles are called a \"core.\""))
          pbMessage(_INTL("If the two of them can take hits from a whole bunch of things, that's a defensive core."))
          pbMessage(_INTL("If together they threaten lots of Pokémon and deal with each others' counters, that's an offensive core."))
          pbMessage(_INTL("Combine both and you have a balanced core. Good cores make for powerful teams."))
          pbMessage(_INTL("You don't need them, but they're a surefire way to give your team some bite."))
      when 1
          setSpeaker(APOLLYON)
          pbMessage(_INTL("The Pokémon you start a fight with is your \"lead.\""))
          pbMessage(_INTL("Start every fight with it and it's a \"dedicated lead.\" Make it a good one."))
          pbMessage(_INTL("Its job is to kick things off in your favor from round one."))
          pbMessage(_INTL("Usually that's by vomiting up a whole bunch of hazards. Sometimes it sets screens and explodes."))
          pbMessage(_INTL("A few just try to delete whatever's on the other side, usually with short-term power boosts like Gems."))
          pbMessage(_INTL("Speaking of which, your opponent is going to have their own lead."))
          pbMessage(_INTL("Stop it. Taunt it, put it to sleep, or put it in the ground."))
      when 2
          setSpeaker(APOLLYON)
          pbMessage(_INTL("The arena is going to very rapidly fill up with nasty pointy things."))
          pbMessage(_INTL("That's because wasting a turn setting them up in the short term pays off big in the long term when they chew up a few Pokémon worth of health over the course of the match."))
          pbMessage(_INTL("If you like being alive, pack something that can clean up hazards – Defog, Terraform, or Rapid Spin, usually."))
          pbMessage(_INTL("Stealth Rocks are the most common hazard, so prioritize hazard removal if you've got lots of Rock-weak Pokémon."))
          pbMessage(_INTL("Remember: if your favorite little gremlin is switching out nine times a match or is cripplingly weak to funny pebbles, put Heavy-Duty Boots on it."))
          pbMessage(_INTL("They're cute and effective."))
      else
          removeSpeaker
          pbMessage(_INTL("You exit the PC."))
          break
      end
  end
end

def snowWhipGuidePC
  pbMessage(_INTL("It's open to a battling guide written by someone with the username \"snowwhip401.\""))
  sectionChoices = []
  sectionChoices.push(_INTL("Even keel"))
  sectionChoices.push(_INTL("Best foot forward"))
  sectionChoices.push(_INTL("Rolling with the punches"))
  sectionChoices.push(_INTL("Exit"))
  loop do
      removeSpeaker
      sectionChoice = pbMessage(_INTL("Which entry would you like to read?"),sectionChoices,sectionChoices.length)
      case sectionChoice
      when 0
          setSpeaker(SNOW_WHIP)
          pbMessage(_INTL("All the little pieces of your team need their own role."))
          pbMessage(_INTL("Use whatever you want; just ensure that it's got something to do and the best odds of doing it."))
          pbMessage(_INTL("Give bulky Pokémon Leftovers and healing moves."))
          pbMessage(_INTL("Give strong, slow Pokémon Focus Sashes, Vests, or ways to speed up."))
          pbMessage(_INTL("You get the idea."))
          pbMessage(_INTL("If you can, try to have all kinds of Pokémon on your team, so you have answers to anything."))
          pbMessage(_INTL("Physical and special bulk and power, type matchups, speed profiles – a diverse team is a diverse toolbox."))
      when 1
          setSpeaker(SNOW_WHIP)
          pbMessage(_INTL("Send out the Pokémon that helps everything else on your team first."))
          pbMessage(_INTL("If you have a weather or a Room to set up, get to it."))
          pbMessage(_INTL("If you don't have a clear, clean gameplan, ruin your opponent's."))
          pbMessage(_INTL("A dedicated lead's worst fear is usually a strong multi-hitting move. Neither Sturdy nor Sash can help them there."))
          pbMessage(_INTL("As opposed to simply trading hazards, outspeeding and KOing a lead before it gets going can give you an early advantage."))
      when 2
          setSpeaker(SNOW_WHIP)
          pbMessage(_INTL("Each Pokémon's utility is defined by the opponent."))
          pbMessage(_INTL("If your opponent has several Fire-type Pokémon, your Primarina is far more valuable."))
          pbMessage(_INTL("Conserve its health and leverage its power."))
          pbMessage(_INTL("In the same match, an Aegislash may be far less valuable – be willing to sacrifice it."))
          pbMessage(_INTL("There's no shame in letting a Pokémon fall in order to get a safe switch to another."))
          pbMessage(_INTL("While they may seem drastic, moves such as Healing Wish or Explosion can turn the tide of a match in a single turn."))
          pbMessage(_INTL("Fainting the user can, if used with finesse, be an advantage – think of them as the ultimate U-Turn."))
      else
          removeSpeaker
          pbMessage(_INTL("You exit the PC."))
          break
      end
  end
end