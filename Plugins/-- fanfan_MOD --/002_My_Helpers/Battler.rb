class PokeBattle_Battler
  def add_random_ability(showcase = false, trigger = true)
    return if fainted?
    added_abil = TA.choose_random_ability(self)
    addAbility(added_abil, showcase, trigger)
  end

  def unique_id
    @pokemon&.unique_id
  end

  def owner_side_all_fainted?
    @battle.pbParty(@index).compact.all?(&:fainted?)
  end

  def mono_type?
    pbTypes(true).length < 2 
  end

  def owned_trainer
    all_trainers = [@battle.player, @battle.opponent].flatten.compact
    all_trainers.each do |trainer|
      return trainer if trainer.party.any? { |pkmn| pkmn.unique_id == unique_id }
    end
    return nil
  end
  
  def replace_pokemon(new_pokemon) # Used by Chrono Revert
    all_trainers = [@battle.player, @battle.opponent].flatten.compact
    all_trainers.each do |trainer|
      trainer.party.each_with_index do |pkmn, idx|
        next unless pkmn.unique_id == unique_id
        trainer.party[idx] = new_pokemon
        return trainer
      end
    end
    return false
  end

  def bigger_side?
    idxOwnSide == @battle.bigger_side
  end

  def owner_party_fainted_count
    return 0 unless owned_trainer
    return owned_trainer.fainted_pkmn_count
  end

  def transformSpeciesEX(newSpecies = nil, abil_id = nil, base_stat = false, stats = false)
    @battle.pbShowAbilitySplash(self, abil_id) if abil_id

    if newSpecies
      newSpeciesData = GameData::Species.get(newSpecies)
    else
      species_list = GameData::Species.keys.shuffle
      newSpeciesData = nil
      species_list.each do |species_id|
        newSpeciesData = GameData::Species.get(species_id)
        next if newSpeciesData.id == self.species_data.id
        next if base_stat && newSpeciesData.base_stat_total < self.species_data.base_stat_total
        break
      end
    end

    newSpecies = newSpeciesData.id

    @battle.scene.pbChangePokemon(self, @pokemon, newSpecies)
    @battle.pbAnimation(:TRANSFORM, self, self)

    applyEffect(:Transform)
    applyEffect(:TransformSpecies, newSpecies)
    pbChangeTypes(newSpecies)
    refreshDataBox
    @battle.pbDisplay(_INTL("{1} transformed into {2}!", pbThis, newSpeciesData.name))

    old_abilities = abilities.clone
    setAbility(newSpeciesData.legalAbilities)
    lost_abilities = old_abilities - abilities

    newStats = @pokemon.getCalculatedStats(newSpecies)
    if stats
      @attack  = newStats[:ATTACK]          if newStats[:ATTACK] > @attack
      @defense = newStats[:DEFENSE]         if newStats[:DEFENSE] > @defense
      @spatk   = newStats[:SPECIAL_ATTACK]  if newStats[:SPECIAL_ATTACK] > @spatk
      @spdef   = newStats[:SPECIAL_DEFENSE] if newStats[:SPECIAL_DEFENSE] > @spdef
      @speed   = newStats[:SPEED]           if newStats[:SPEED] > @speed
    else
      @attack  = newStats[:ATTACK]
      @defense = newStats[:DEFENSE]
      @spatk   = newStats[:SPECIAL_ATTACK]
      @spdef   = newStats[:SPECIAL_DEFENSE]
      @speed   = newStats[:SPEED]
    end
    disableBaseStatEffects

    pbOnAbilitiesLost(lost_abilities)
    # Trigger abilities
    pbEffectsOnSwitchIn

    if abil_id
      @ability_ids << abil_id
      @addedAbilities << abil_id
      @battle.pbHideAbilitySplash(self)
    end

    @battle.pbCalculatePriority(false, [@index])

    @battle.ai_update_abilities(self, abils: @ability_ids)
  end

  def has_all_abils?
    TA.all_available_abilities.all? { |abil| abilities.include?(abil) }
  end

  def should_apply_adaptive_ai_v4?(target, move)
    hasActiveAbility?(:ADAPTIVEAIV4) && move.damagingMove?
  end

  def should_apply_adaptive_ai_v3?(target, move)
    hasActiveAbility?([:ADAPTIVEAIV3, :ADAPTIVEAIV4]) && move.damagingMove?
  end

  def should_apply_adaptive_ai_v2?(target, move)
    hasActiveAbility?(:ADAPTIVEAIV2) && move.damagingMove?
  end

  def should_apply_adaptive_ai_v1?(target, move)
    hasActiveAbility?(:ADAPTIVEAIV1) && move.damagingMove?
  end
end