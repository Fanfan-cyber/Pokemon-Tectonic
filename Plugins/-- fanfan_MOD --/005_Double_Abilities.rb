class Pokemon
  def legal_abilities
    self.species_data.legalAbilities
  end
  alias species_abilities legal_abilities

  def species_abilities_names(index = nil)
    self.species_data.legalAbilitiesNames(index)
  end

  def has_multi_abilities?
    self.species_data.hasMultiAbilities?
  end

  def add_all_other_abilities
    self.add_other_abilities
    self.add_others
  end

  def add_other_abilities
    self.species_abilities.each { |abil| self.addExtraAbility(abil) if abil != self.ability_id }
  end

  def add_others
  end

  def abilities
    @abilities = ([self.ability_id] | self.extraAbilities).compact
    @abilities.delete_if { |abil_id| !self.legal_abilities.include?(abil_id) } if !$DEBUG
    @abilities
  end

  def hasAbility?(check_ability = nil)
    return !self.ability.nil? if check_ability.nil?
    return self.abilities.include?(check_ability) if check_ability.is_a?(Symbol)
    self.abilities.any? { |abil_id| check_ability.id == abil_id }
  end
end

class PokeBattle_Battle
  def ai_update_abilities(battler = nil, abils: nil)
    if battler&.pbOwnedByPlayer?
      abils = [abils].compact if !abils.is_a?(Array)
      @knownAbilities[battler.pokemon.personalID] = []
      @knownAbilities[battler.pokemon.personalID].concat(abils)
      echoln("[ABILITY UPDATE] Player's side #{battler.name}: #{@knownAbilities[battler.pokemon.personalID]}.")
    else
      echoln("===AI KNOWN ABILITIES===")
      @knownAbilities = {}
      @party1.each do |pokemon|
        @knownAbilities[pokemon.personalID] = []
        @knownAbilities[pokemon.personalID].concat(pokemon.abilities)
        echoln("[ABILITY LEARN] Player's side #{pokemon.name}: #{@knownAbilities[pokemon.personalID]}.")
      end
    end
  end
end

class PokemonSummary_Scene
  def pbAbilitiesSelection
    commands = {}
    @pokemon.species_abilities.each do |ability|
      ability_name = GameData::Ability.try_get(ability)&.name || _INTL("#{ability.to_s.capitalize} (Unimplemented)")
      commands[ability] = _INTL("Ability: {1}", ability_name)
    end
    commands[:cancel] = _INTL("Cancel")
    command = pbShowCommands(commands.values)
    command_list = commands.clone.to_a
    @pokemon.species_abilities.each_with_index do |ability, index|
      next if command_list[command][0] != ability
      ability_obj = GameData::Ability.try_get(ability)
      ability_description = ability_obj&.description || _INTL("This ability is unimplemented now.")
      ability_description = ability_obj&.details || _INTL("This ability is unimplemented now.") if ability_obj.has_details?
      pbMessage(ability_description)
      next if !ability_obj || @pokemon.ability_id == ability || !@pokemon.has_multi_abilities?
      if pbConfirm(_INTL("Changes the displaying ability to {1}?", ability_obj.name))
        if $PokemonBag.pbHasItem?(:ABILITYCAPSULE)
          $PokemonBag.pbDeleteItem(:ABILITYCAPSULE)
          @pokemon.ability_index = index
          @pokemon.ability = nil
          pbMessage(_INTL("{1}'s displaying ability now is {2}.", @pokemon.speciesName, ability_obj.name))
        else
          pbMessage(_INTL("You don't have any Ability Capsule in your bag."))
        end
      end
      break
    end
  end
end