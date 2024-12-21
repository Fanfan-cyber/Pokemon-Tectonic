class PokeBattle_Battler
  # 为精灵从特性库中随机添加一个特性
  def add_random_ability(showcase = false, trigger = true)
    return if fainted?
    added_abil = choose_random_ability(self)
    addAbility(added_abil, showcase, trigger)
  end

  # 精灵的ID
  def unique_id
    @pokemon.unique_id
  end

  # 检查精灵所在的一方是否已经全部濒死
  def owner_side_all_fainted?
    @battle.pbParty(@index).all?(&:fainted?)
  end

  # 将精灵变为其他随机的一只精灵
  def transformSpeciesRandom(abil_id = nil, stats = false)
    @battle.pbShowAbilitySplash(self, abil_id) if abil_id

    species_list = GameData::Species.keys.shuffle
    species_data = nil
    species_list.each do |species|
      species_data = GameData::Species.get(species)
      next if species_data.base_stat_total < self.species_data.base_stat_total
      break
    end
    species_id = species_data.id

    @battle.scene.pbChangePokemon(self, @pokemon, species_id)

    applyEffect(:Transform)
    applyEffect(:TransformSpecies, species_id)
    pbChangeTypes(species_id)
    refreshDataBox
    @battle.pbDisplay(_INTL("{1} transformed into {2}!", pbThis, species_data.name))

    old_abilities = abilities.clone
    setAbility(species_data.legalAbilities)
    lost_abilities = old_abilities - abilities

    newStats = @pokemon.getCalculatedStats(species_id)
    if stats
      @attack  = newStats[:ATTACK] if newStats[:ATTACK] > @attack
      @defense = newStats[:DEFENSE] if newStats[:DEFENSE] > @defense
      @spatk   = newStats[:SPECIAL_ATTACK] if newStats[:SPECIAL_ATTACK] > @spatk
      @spdef   = newStats[:SPECIAL_DEFENSE] if newStats[:SPECIAL_DEFENSE] > @spdef
      @speed   = newStats[:SPEED] if newStats[:SPEED] > @speed
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

    @battle.ai_update_abilities(self, abils: @ability_ids)
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