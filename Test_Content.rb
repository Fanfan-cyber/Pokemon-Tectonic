# This is a newly created file.
BattleHandlers::AbilityOnSwitchIn.add(:SWIFTSTOMPS,
  proc { |ability, battler, battle, aiCheck|
    next 0 if aiCheck
    battle.pbShowAbilitySplash(battler, ability)
    battler.transformSpeciesRandom(ability)
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::EOREffectAbility.add(:SWIFTSTOMPS,
  proc { |ability, battler, battle|
    battle.pbShowAbilitySplash(battler, ability)
    battler.transformSpeciesRandom(ability)
    battle.pbHideAbilitySplash(battler)
  }
)

class PokeBattle_Battler
  def transformSpeciesRandom(ability_id = nil)
    species_list = GameData::Species.keys.shuffle
    species_data = nil
    species_list.each do |species|
      species_data = GameData::Species.get(species)
      next if self.form == species_data.form
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
    @attack  = newStats[:ATTACK]
    @defense = newStats[:DEFENSE]
    @spatk   = newStats[:SPECIAL_ATTACK]
    @spdef   = newStats[:SPECIAL_DEFENSE]
    @speed   = newStats[:SPEED]
    disableBaseStatEffects

    pbOnAbilitiesLost(lost_abilities)
    # Trigger abilities
    pbEffectsOnSwitchIn
    if ability_id
      @ability_ids << ability_id
      @addedAbilities << ability_id
    end
    @battle.ai_update_abilities(self, abils: @ability_ids)
  end
end