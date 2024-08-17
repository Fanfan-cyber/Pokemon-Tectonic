class Pokemon
  alias fanfan_initialize initialize
  def initialize(species, level, owner = $Trainer, withMoves = true, recheck_form = true)
    fanfan_initialize(species, level, owner, withMoves, recheck_form)
	addSpeciesAbility
	addInnateSet
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

  def legalAbilities
    speciesAbility | innateSet | [ability_id]
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
	  @pokemon.addSpeciesAbility # old save compatibility
	  @pokemon.addInnateSet # old save compatibility
	  @pokemon.removeIllegalAbilities # legality check
	  @battle.learnPlayerAllAbility(self) # ai update abilities
	end
    fanfan_resetAbilities
	@addedAbilities.concat(@pokemon.abilities).uniq! # for displaying abilities
  end
end

class PokeBattle_Battle
  alias fanfan_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    fanfan_initialize(scene, p1, p2, player, opponent)
    learnPlayerAllAbility
  end

  def learnPlayerAllAbility(battler = nil)
    if !battler
	  echoln("===AI KNOWN ABILITIES===")
      @party1.each do |pokemon|
	    pokemon.abilities.each do |ability|
	      @knownAbilities[pokemon.personalID].push(ability)
		  echoln("Player's side pokemon #{pokemon.name}'s ability #{ability} is known by the AI.")
		  @knownAbilities[pokemon.personalID].uniq!
	    end
      end
	else
	  battler.pokemon.abilities.each do |ability|
	    @knownAbilities[battler.pokemon.personalID] = []
	    @knownAbilities[battler.pokemon.personalID].push(ability)
	    echoln("[ABILITY UPDATE] Player's side pokemon #{battler.pokemon.name}'s ability #{ability} is known by the AI.")
	  end
	end
  end

  def initializeKnownMoves(pokemon)
    pokemon.moves.each do |move|
	  @knownMoves[pokemon.personalID] = []
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