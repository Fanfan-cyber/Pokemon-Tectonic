# This is a newly created file.
BattleHandlers::AbilityOnSwitchIn.add(:SWIFTSTOMPS,
  proc { |ability, battler, battle, aiCheck|
    next 0 if aiCheck
    battle.pbShowAbilitySplash(battler, ability)
    species = GameData::Species.keys.sample
    species_data = GameData::Species.get(species)
    battler.transformSpecies(species, species_data.form)
    battler.abilities << :SWIFTSTOMPS
    battler.addedAbilities << :SWIFTSTOMPS
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::EOREffectAbility.add(:SWIFTSTOMPS,
  proc { |ability, battler, battle|
    battle.pbShowAbilitySplash(battler, ability)
    species = GameData::Species.keys.sample
    battler.transformSpecies(species)
    battler.abilities << :SWIFTSTOMPS
    battler.addedAbilities << :SWIFTSTOMPS
    battle.pbHideAbilitySplash(battler)
  }
)

class PokeBattle_Battler
  def transformSpecies(newSpecies, newForm = nil)
    self.form = newForm if newForm
    @battle.scene.pbChangePokemon(self, @pokemon, newSpecies)

    newSpeciesData = GameData::Species.get(newSpecies)
    applyEffect(:Transform)
    applyEffect(:TransformSpecies, newSpecies)
    pbChangeTypes(newSpecies)
    refreshDataBox
    @battle.pbDisplay(_INTL("{1} transformed into {2}!", pbThis, newSpeciesData.name))
    legalAbilities = newSpeciesData.legalAbilities

    lost_abilities = abilities - legalAbilities
    setAbility(legalAbilities)
    # newAbility = legalAbilities[@pokemon.ability_index] || legalAbilities[0]
    # replaceAbility(newAbility) unless hasAbility?(newAbility)

    newStats = @pokemon.getCalculatedStats(newSpecies)
    @attack  = newStats[:ATTACK]
    @defense = newStats[:DEFENSE]
    @spatk   = newStats[:SPECIAL_ATTACK]
    @spdef   = newStats[:SPECIAL_DEFENSE]
    @speed   = newStats[:SPEED]
    disableBaseStatEffects

    pbOnAbilitiesLost(lost_abilities)
    # Trigger abilities
    pbEffectsOnSwitchIn
  end
end