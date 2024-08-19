module Settings
  ER_MODE = true
end

class Pokemon
  alias fanfan_initialize initialize
  def initialize(species, level, owner = $Trainer, withMoves = true, recheck_form = true)
    fanfan_initialize(species, level, owner, withMoves, recheck_form)
    addSpeciesAbilityandInnates
  end

  def ability_id # it could be nil
    recalculateAbilityFromIndex if @ability.nil?
    @ability
  end

  def ability
    GameData::Ability.try_get(ability_id)
  end

  def extraAbilities
    @extraAbilities ||= []
  end

  def abilities
    ([ability_id] | extraAbilities).compact
  end

  def addExtraAbility(ability)
    extraAbilities.push(ability) if !extraAbilities.include?(ability) && ability_id != ability
  end

  def speciesAbility
	species_data.legalAbilities
  end

  def getSpeciesAbilityName(index = nil)
    ability_names = speciesAbility.map { |ability_id| GameData::Ability.get(ability_id).name }
	return ability_names[index] if index && index.between?(0, ability_names.length - 1)
    "#{ability_names[0..-1].join(", ")}"
  end

  def addSpeciesAbility
    speciesAbility.each { |ability| addExtraAbility(ability) }
  end

  def innateSet
    return [] # TO-DO
    INNATE_SET[@species]&.sample || []
  end

  def addInnateSet
    innateSet.each { |ability| addExtraAbility(ability) } 
  end

  def addSpeciesAbilityandInnates
    return if !Settings::ER_MODE
	addSpeciesAbility
	addInnateSet
  end

  def legalAbilities
    return speciesAbility | innateSet | [ability_id] if Settings::ER_MODE
	[ability_id]
  end

  def removeIllegalAbilities
    extraAbilities.delete_if { |ability| !legalAbilities.include?(ability) }
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
	  @pokemon.addSpeciesAbilityandInnates
	  @pokemon.removeIllegalAbilities # legality check
	end
    fanfan_resetAbilities
	@battle.aiUpdateAbility(self) if pbOwnedByPlayer? # ai update abilities
	addAbilitiesDisplayInfo # for displaying abilities
  end

  def addAbilitiesDisplayInfo
    @addedAbilities.concat(@pokemon.abilities).uniq! if Settings::ER_MODE
  end
end

class PokeBattle_Battle
  alias fanfan_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    fanfan_initialize(scene, p1, p2, player, opponent)
    aiUpdateAbility
  end

  def aiUpdateAbility(battler = nil, abilities: nil)
    return if !Settings::ER_MODE
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
	  battler.pokemon.abilities.each do |ability|
	    @knownAbilities[battler.pokemon.personalID].push(ability)
	    echoln("[ABILITY UPDATE] Player's side pokemon #{battler.pokemon.name}'s ability #{ability} is known by the AI.")
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
    pokemon.moves.each do |move|
	  @knownMoves[pokemon.personalID] = []
	  next if !pokemon.boss? && !aiAutoKnowsMove?(move, pokemon) && !Settings::ER_MODE
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
        @pokemon.ability_index = index
        @pokemon.ability = nil
        pbMessage(_INTL("{1}'s displaying ability now is {2}.", @pokemon.speciesName, ability_obj.name))
      end
    end
    @pokemon.innateSet.each do |innate|
      next if command_list[command][0] != innate
      ability_obj = GameData::Ability.try_get(innate)
      innate_description = ability_obj&.description || _INTL("This innate is unimplemented now.")
      pbMessage(innate_description)
    end
  end
end