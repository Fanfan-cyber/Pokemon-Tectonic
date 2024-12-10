class Pokemon
  ADAPTIVE_AI = %i[ADAPTIVEAIV1 ADAPTIVEAIV2 ADAPTIVEAIV3 ADAPTIVEAIV4]

  def species_abilities
    species_data.legalAbilities
  end
  alias legal_abilities species_abilities

  def species_abilities_names(index = nil)
    species_data.legalAbilitiesNames(index)
  end

  def has_multi_abilities?
    species_data.hasMultiAbilities?
  end

  def add_all_other_abilities
  end

  def recalc_species_abilities
    @extraAbilities.clear
    species_abilities.each { |abil| addExtraAbility(abil) }
  end

  def abilities
    ([ability_id] | species_abilities | extraAbilities).compact
  end

  def hasAbility?(check_ability = nil)
    return !ability.nil? if check_ability.nil?
    return abilities.include?(check_ability) if check_ability.is_a?(Symbol)
    abilities.any? { |abil_id| check_ability.id == abil_id }
  end

  def hasMultipleItemAbility?
    abilities.any? { |abil_id| GameData::Ability.get(abil_id).is_multiple_item_ability? && abil_id != :STICKYFINGERS }
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
        @knownAbilities[pokemon.unique_id] = []
        @knownAbilities[pokemon.unique_id].concat(pokemon.abilities)
        echoln("[ABILITY LEARN] Player's side #{pokemon.name}: #{@knownAbilities[pokemon.unique_id]}.")
      end
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

module AbilityRecorder
  def self.check_ability_recorder(battle, battler)
    return if $Trainer.get_ta(:battle_loader)
    return if !battle.trainerBattle?
    return if battler.pbOwnedByPlayer?
    abils = $Trainer.ability_recorder
    abils_recorded = []
    battler.legalAbilities.each do |abil|
      next if abils.has?(abil)
      abils << abil
      abils_recorded << abil
    end
    return if abils_recorded.empty?
    abilities_names = abils_recorded.map { |abil_id| getAbilityName(abil_id) }
    battle.pbDisplay(_INTL("Ability Recorder recorded {1}'s {2}!", battler.pbThis(true), abilities_names.quick_join))
  end

  def self.oppen_ability_recorder(pkmn)
    abils = $Trainer.ability_recorder
    chose = change_ability_choose_from_list(pkmn, abils)
    return false if !chose
    abils.delete(chose)
    return true
  end

  def self.has_ability_recorded?
    $Trainer.ability_recorder.length > 0
  end
end