module Settings
  ER_MODE = true
  CHINESE_TEXT = false # please dont touch this if eng is yer native
end

def erMode?
  Settings::ER_MODE
end

def chinese?
  Settings::CHINESE_TEXT
end

class Pokemon
  alias fanfan_initialize initialize
  def initialize(species, level, owner = $Trainer, withMoves = true, recheck_form = true)
    fanfan_initialize(species, level, owner, withMoves, recheck_form)
    addAnotherAbilityAndInnates
  end

  def ability_id # it may be a nil, so be careful
    recalculateAbilityFromIndex if @ability.nil?
    @ability
  end

  def ability # an abil obj
    GameData::Ability.try_get(ability_id)
  end

  def extraAbilities
    @extraAbilities ||= []
  end

  def abilities
    ([ability_id] | extraAbilities).compact
  end

  def addExtraAbility(ability)
    extraAbilities.push(ability) if !abilities.include?(ability)
  end

  def speciesAbility
	species_data.legalAbilities
  end

  def anotherAbility
    speciesAbility.select { |ability| ability != ability_id }
  end

  def getSpeciesAbilityName(index = nil)
    ability_names = speciesAbility.map { |ability_id| GameData::Ability.get(ability_id).name }
	return "#{ability_names[0..-1].join(", ")}" if !index
	ability_names[index]
  end

  def addAnotherAbility
    anotherAbility.each { |ability| addExtraAbility(ability) }
  end

  def innateSet
    return [] # TO-DO
  end

  def addInnateSet
    innateSet.each { |ability| addExtraAbility(ability) } 
  end

  def addAnotherAbilityAndInnates
    return if !erMode?
	addAnotherAbility
	addInnateSet
  end

  def legalAbilities
    return (speciesAbility | innateSet | [ability_id]) if erMode?
	[ability_id]
  end

  def removeIllegalAbilities
    extraAbilities.delete_if { |ability| !legalAbilities.include?(ability) }
  end

  def removeDupAbility
    extraAbilities.delete(ability_id)
  end

  def hasAbility?(check_ability = nil)
    return !ability.nil? if check_ability.nil?
	return abilities.include?(check_ability) if check_ability.is_a?(Symbol)
	abilities.any? { |ability_id| check_ability.id == ability_id }
  end
end

class PokeBattle_Battler
  alias fanfan_resetAbilities resetAbilities
  def resetAbilities(initialization = false)
    if pbOwnedByPlayer?
      @pokemon.addAnotherAbilityAndInnates
	  @pokemon.removeIllegalAbilities # legality check
	end
	@pokemon.removeDupAbility # prevent an abil from triggering twice
    fanfan_resetAbilities(initialization)
	@battle.aiUpdateAbility(self) if pbOwnedByPlayer? # ai update ablis
	addAbilitiesDisplayInfo # for displaying all ablis
  end

  def addAbilitiesDisplayInfo
    @addedAbilities.concat(abilities).uniq! if erMode?
  end
end

class PokeBattle_Battle
  alias fanfan_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    fanfan_initialize(scene, p1, p2, player, opponent)
    aiUpdateAbility # ai knows all abils
  end

  def aiUpdateAbility(battler = nil, abilities: nil)
    return if !erMode?
    if !battler
	  echoln("===AI KNOWN ABILITIES===")
	  @knownAbilities = {}
      @party1.each do |pokemon|
	    @knownAbilities[pokemon.personalID] = []
	    pokemon.abilities.each do |ability|
	      @knownAbilities[pokemon.personalID].push(ability)
		  echoln("Player's side pokemon #{pokemon.name}'s ability #{ability} is known by the AI.")
	    end
      end
	elsif !abilities
	  @knownAbilities[battler.pokemon.personalID] = []
	  battler.abilities.each do |ability|
	    @knownAbilities[battler.pokemon.personalID].push(ability)
	    echoln("[ABILITY UPDATE] Player's side pokemon #{battler.name}'s ability #{ability} is known by the AI.")
	  end
	else
	  abilities = [abilities] if !abilities.is_a?(Array)
	  @knownAbilities[battler.pokemon.personalID] = []
	  abilities.each do |ability|
	    @knownAbilities[battler.pokemon.personalID].push(ability)
	    echoln("[ABILITY UPDATE] Player's side pokemon #{battler.pokemon.name}'s ability #{ability} is known by the AI.")
	  end
	end
  end

  def initializeKnownMoves(pokemon)
    @knownMoves[pokemon.personalID] = []
    pokemon.moves.each do |move|
	  next if !pokemon.boss? && !aiAutoKnowsMove?(move, pokemon) && !erMode?
      @knownMoves[pokemon.personalID].push(move.id)
      echoln("Pokemon #{pokemon.name}'s move #{move.name} is known by the AI")
    end
  end
end

class AbilitySplashAppearAnimation < PokeBattle_Animation
  alias fanfan_createProcesses createProcesses
  def createProcesses
    fanfan_createProcesses
	bar = addSprite(@sprites["abilityBar_#{@side}"])
    bar.setSE(0, "Battle ability")
  end
end

class PokemonSummary_Scene
  def pbAbilitiesSelection
    pbMessage(_INTL("Warning: The Innate System doesn't work now."))
    commands = {}
    @pokemon.speciesAbility.each do |ability|
      ability_name = GameData::Ability.try_get(ability)&.name || _INTL("#{ability.to_s.capitalize} (Unimplemented)")
      commands[ability] = _INTL("Ability: {1}", ability_name)
    end
    @pokemon.innateSet.each do |innate|
      innate_name = GameData::Ability.try_get(innate)&.name || _INTL("#{innate.to_s.capitalize} (Unimplemented)")
      commands[innate] = _INTL("Innate: {1}", innate_name)
    end
    commands[:cancel] = _INTL("Cancel")
    command = pbShowCommands(commands.values)
    command_list = commands.clone.to_a
    @pokemon.speciesAbility.each_with_index do |ability, index|
      next if command_list[command][0] != ability
      ability_obj = GameData::Ability.try_get(ability)
      ability_description = ability_obj&.description || _INTL("This ability is unimplemented now.")
      pbMessage(ability_description)
      next if !ability_obj || @pokemon.ability_id == ability
      if pbConfirm(_INTL("Do you want to change the displaying ability to {1}?", ability_obj.name))
	    if $PokemonBag.pbHasItem?(:ABILITYCAPSULE)
		  $PokemonBag.pbDeleteItem(:ABILITYCAPSULE)
          @pokemon.ability_index = index
          @pokemon.ability = nil
          pbMessage(_INTL("{1}'s displaying ability now is {2}.", @pokemon.speciesName, ability_obj.name))
		else
		  pbMessage(_INTL("You don't have any Ability Capsule in your bag."))
		end
      end
	  break
    end
    @pokemon.innateSet.each do |innate|
      next if command_list[command][0] != innate
      ability_obj = GameData::Ability.try_get(innate)
      innate_description = ability_obj&.description || _INTL("This innate is unimplemented now.")
      pbMessage(innate_description)
	  break
    end
  end
end

if erMode?

def battleGuideAbilitiesHash
    return {
        _INTL("What are abilities?") => _INTL("Abilities are special powers that Pokémon can have based on their species. Most Pokémon can have 2 possible abilities. All abilities activate."),
        _INTL("Ability Effects") => _INTL("Abilities do a wide variety of different things. Understanding your team's abilities is important to winning."),
        _INTL("Checking Abilities") => _INTL("Check your Pokémon's summary to see what displaying ability they have. Use the MasterDex to read about the abilities of enemy Pokémon during battle."),
        _INTL("Choosing Abilities") => _INTL("A Pokémon's displaying ability is one of the two its species can have, randomly chosen when you get it. You can use Ability Capsules to swap to the other."),
        _INTL("Conditional Abilities") => _INTL("Many abilities only do things under certain circumstances. Building around Weather and Room-synergy abilities is a common strategy."),
        _INTL("Effect Of Evolution") => _INTL("A Pokémon's ability tends to stay the same when evolving, but can change. When this happens, the game will alert you."),
        _INTL("Defeating Abilities") => _INTL("An enemy Trainer's ability too much? Abilities like Neutralizing Gas, and moves like Gastro Acid, can suppress abilities in battle."),
        _INTL("Swapping Abilities") => _INTL("Moves like Skill Swap can be used to give a new ability to Pokémon during battle, enabling unique and creative team synergies."),
    }
end

end