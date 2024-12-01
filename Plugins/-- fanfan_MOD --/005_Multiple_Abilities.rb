class Pokemon
  ADAPTIVE_AI = %i[ADAPTIVEAIV1 ADAPTIVEAIV2 ADAPTIVEAIV3 ADAPTIVEAIV4]

  def legal_abilities
    species_data.legalAbilities
  end
  alias species_abilities legal_abilities

  def species_abilities_names(index = nil)
    species_data.legalAbilitiesNames(index)
  end

  def has_multi_abilities?
    species_data.hasMultiAbilities?
  end

  def add_all_other_abilities
    add_species_abilities
    add_others
  end

  def add_species_abilities
    species_abilities.each { |abil| addExtraAbility(abil) if abil != ability_id }
  end

  def add_others
  end

  def abilities
    @abilities = ([ability_id] | extraAbilities).compact
    @abilities.delete_if { |abil_id| !legal_abilities.include?(abil_id) && !ADAPTIVE_AI.include?(abil_id) } if !$DEBUG
    @abilities
  end

  def hasAbility?(check_ability = nil)
    return !ability.nil? if check_ability.nil?
    return abilities.include?(check_ability) if check_ability.is_a?(Symbol)
    abilities.any? { |abil_id| check_ability.id == abil_id }
  end
end

class PokeBattle_Battle
  def ai_update_abilities(battler = nil, abils: nil)
    if battler&.pbOwnedByPlayer?
      abils = [abils].compact if !abils.is_a?(Array)
      @knownAbilities[battler.unique_id] = []
      @knownAbilities[battler.unique_id].concat(abils)
      echoln("[ABILITY UPDATE] Player's side #{battler.name}: #{@knownAbilities[battler.unique_id]}.")
    else
      echoln("===AI KNOWN ABILITIES===")
      @knownAbilities = {}
      @party1.each do |pokemon|
        pokemon.add_all_other_abilities
        @knownAbilities[pokemon.unique_id] = []
        @knownAbilities[pokemon.unique_id].concat(pokemon.abilities)
        echoln("[ABILITY LEARN] Player's side #{pokemon.name}: #{@knownAbilities[pokemon.unique_id]}.")
      end
      @party2.each { |pokemon| pokemon.add_all_other_abilities }
    end
  end
end

class PokemonSummary_Scene
  def pbAbilitiesSelection
    commands = []
    battler = nil
    @battle&.eachSameSideBattler { |b| battler = b if b.pokemonIndex == @partyindex }
    abil_list = battler ? battler.abilities : @pokemon.abilities
    abil_list.each do |abil|
      abil_name = GameData::Ability.try_get(abil)&.name || _INTL("(Unimplemented)")
      commands << _INTL("Ability: {1}", abil_name)
    end
    index = pbShowCommands(commands)
    return if index < 0
    abil = abil_list[index]
    abil_obj = GameData::Ability.try_get(abil)
    abil_des = abil_obj&.description || _INTL("This ability has not been implemented.")
    abil_des = abil_obj&.details if abil_obj.has_details?
    pbMessage(abil_des)
  end
end