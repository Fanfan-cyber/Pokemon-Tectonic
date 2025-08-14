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

  def has_main_ability?
    ability_id && !species_abilities.has?(ability_id)
  end

  def abilities
    if TA.get(:monoabil) && used_by_player?
      [ability_id].compact
    else
      main_abil = TA.get(:customabil) ? [ability_id] : []
      (main_abil | species_abilities | extraAbilities).compact
    end
  end

  def hasAbility?(check_ability = nil)
    return !ability.nil? if check_ability.nil?
    return abilities.include?(check_ability) if check_ability.is_a?(Symbol)
    return abilities.any? { |abil_id| check_ability.include?(abil_id) } if check_ability.is_a?(Array)
    abilities.any? { |abil_id| check_ability.id == abil_id }
  end

  def hasMultipleItemAbility?
    abilities.any? { |abil_id| GameData::Ability.get(abil_id).is_multiple_item_ability? && abil_id != :STICKYFINGERS }
  end
end

class PokeBattle_Battle
  def ai_update_abilities(battler = nil, abils: nil)
    return if battler && !battler.pbOwnedByPlayer?
    if battler
      abils = [abils].compact unless abils.is_a?(Array)
      @knownAbilities[battler.unique_id] = []
      @knownAbilities[battler.unique_id].concat(abils)
      echoln("[ABILITY UPDATE] #{battler.name} => #{@knownAbilities[battler.unique_id].map { |abil_id| getAbilityName(abil_id) }}")
    else
      echoln("===AI KNOWN ABILITIES===")
      @knownAbilities = {}
      @party1.each do |pokemon|
        @knownAbilities[pokemon.unique_id] = []
        @knownAbilities[pokemon.unique_id].concat(pokemon.abilities)
        echoln("[ABILITY LEARN] #{pokemon.name} => #{@knownAbilities[pokemon.unique_id].map { |abil_id| getAbilityName(abil_id) }}")
      end
    end
  end
end

class PokemonSummary_Scene
  def pbAbilitiesSelection
    commands = []
    abil_list = @pokemon.abilities

    @battle&.eachSameSideBattler do |battler|
      next if battler.unique_id != @pokemon.unique_id
      abil_list = battler.abilities
      break
    end

    if abil_list.empty?
      pbMessage(_INTL("The Pokémon don't have any abilities."))
      return
    end
    abil_list.each do |abil|
      abil_name = GameData::Ability.try_get(abil)&.name || _INTL("(Unimplemented)")
      commands << _INTL("Ability: {1}", abil_name)
    end
    loop do
      index = pbShowCommands(commands)
      return if index < 0
      abil = abil_list[index]
      abil_obj = GameData::Ability.try_get(abil)
      abil_des = abil_obj&.description || _INTL("This ability has not been implemented.")
      abil_des = abil_obj&.details if abil_obj&.has_details?
      pbMessage(abil_des)
    end
  end
end

module AbilityRecorder
  def self.check_ability_recorder(battle, battler)
    return if TA.get(:battle_loader)
    return unless battle.trainerBattle?
    return if battler.pbOwnedByPlayer?
    abils = $Trainer.ability_recorder
    abils_recorded = []
    battler.legalAbilities.each do |abil|
      next if abils.has?(abil)
      abils << abil
      abils_recorded << abil
    end
    return unless TA.get(:customabil)
    return if abils_recorded.empty?
    abilities_names = abils_recorded.map { |abil_id| getAbilityName(abil_id) }
    battle.pbDisplay(_INTL("Ability Recorder recorded {1}'s {2}!", battler.pbThis(true), abilities_names.quick_join))
  end

  def self.oppen_ability_recorder(pkmn)
    abils = $Trainer.ability_recorder
    chose = change_ability_choose_from_list(pkmn, abils)
    return false unless chose
    abils.delete(chose)
    return true
  end

  def self.has_ability_recorded?
    $Trainer.ability_recorder.length > 0
  end
end