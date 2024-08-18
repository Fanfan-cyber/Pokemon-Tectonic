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
  end

  def hasAbility?(check_ability = nil)
    return !ability.nil? if check_ability.nil?
	return abilities.include?(check_ability) if check_ability.is_a?(Symbol)
	abilities.each do |ability_id|
      return true if check_ability.id == ability_id
	end
	false
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
      @party1.each do |pokemon|
	    pokemon.abilities.each do |ability|
	      @knownAbilities[pokemon.personalID].push(ability)
		  echoln("Player's side pokemon #{pokemon.name}'s ability #{ability} is known by the AI.")
		  @knownAbilities[pokemon.personalID].uniq!
	    end
      end
	elsif !abilities
	  battler.pokemon.abilities.each do |ability|
	    @knownAbilities[battler.pokemon.personalID] = []
	    @knownAbilities[battler.pokemon.personalID].push(ability)
	    echoln("[ABILITY UPDATE] Player's side pokemon #{battler.pokemon.name}'s ability #{ability} is known by the AI.")
	  end
	else
	  abilities = [abilities] if !abilities.is_a?(Array)
	  abilities.each do |ability|
	    @knownAbilities[battler.pokemon.personalID] = []
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