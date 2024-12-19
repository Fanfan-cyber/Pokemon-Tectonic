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