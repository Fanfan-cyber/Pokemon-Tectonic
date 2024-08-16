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

  def addExtraAbility(ability)
    extraAbilities.push(ability) if !extraAbilities.include?(ability) && ability_id != ability
  end

  def speciesAbility
	species_data.abilities.map { |ability| ability }.compact
  end

  def addSpeciesAbility
    speciesAbility.each { |ability| addExtraAbility(ability) }
  end

  def innateSet
    return # TO-DO
    INNATE_SET[@species]&.sample
  end

  def addInnateSet
    innateSet&.each { |ability| addExtraAbility(ability) } 
  end
end

class PokeBattle_Battler
  alias fanfan_resetAbilities resetAbilities
  def resetAbilities(initialization = false)
	@pokemon.addSpeciesAbility # old save compatibility
	@pokemon.addInnateSet # old save compatibility
    fanfan_resetAbilities
	@addedAbilities.concat(@pokemon.speciesAbility).uniq! # for displaying abilities
  end
end

class PokeBattle_Battle
  alias fanfan_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    fanfan_initialize(scene, p1, p2, player, opponent)
    # System for learning the player's abilities
	echoln("===PLAYER KNOWN ABILITIES===")
    #@knownAbilities = Hash.new { |hash, key| hash[key] = [] }
    @party1.each do |pokemon|
	  abilityToKnow = [pokemon.ability_id] | pokemon.extraAbilities
	  abilityToKnow.compact.each do |ability|
	    next if @knownAbilities[pokemon.personalID].include?(ability)
	    @knownAbilities[pokemon.personalID].push(ability)
		echoln("Player's side pokemon #{pokemon.name}'s ability #{ability} is known by the AI.")
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