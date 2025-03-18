def get_language
  Settings::LANGUAGES[$Options.language || 0][0]
end

def is_chinese?
  Settings::LANGUAGES[$Options.language || 0][0] == "Simplified Chinese"
end

def party_dup_item?
  $Trainer&.party_dup_item?
end

def has_species_party?(species, form = -1)
  $Trainer&.has_species?(species, form)
end

def has_species_pc?(species, form = -1)
  pbEachPokemon do |pkmn, _box|
    return true if pkmn.isSpecies?(species) && (form < 0 || pkmn.form == form)
  end
  return false
end

def has_species?(species, form = -1)
  has_species_party?(species, form) || has_species_pc?(species, form)
end

def pbGetPartyIndex(species, form = 0)
  $Trainer&.pbGetPartyIndex(species, form)
end

def pbGetPartyPokemon(index)
  $Trainer&.party[index]
end

def pbSwapPartyPosition(species, new_index = 0, form = 0)
  $Trainer&.pbSwapPartyPosition(species, new_index, form)
end

def pbChoosePokemonEX(ableProc = nil, allowIneligible = false)
	index = 0
	pbFadeOutIn {
		scene = PokemonParty_Scene.new
		screen = PokemonPartyScreen.new(scene, $Trainer.party)
		if ableProc
		  index = screen.pbChooseAblePokemon(ableProc, allowIneligible)
		else
      screen.pbStartScene(_INTL("Choose a Pokémon."), false)
      index = screen.pbChoosePokemon
      screen.pbEndScene
		end
	}
  pkmn = $Trainer.party[index]
  pkmn = nil if index == -1
  return pkmn, index, pkmn&.name
end

def pbChoosePkmnFromListEX(message, input_ids, must_choose = false)
  names = []
  ids   = []
  input_ids.each do |id|
    if id.is_a?(Pokemon)
      names.push(id.name)
      ids.push(id)
    else
      next unless GameData::Species.exists?(id)
      pkmn = GameData::Species.get(id)
      names.push(pkmn.name)
      ids.push(pkmn.id)
    end
  end
  return if names.empty?
  unless must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

def pbChooseAbilityFromListEX(message, input_ids, must_choose = false)
  names = []
  ids   = []
  input_ids.each do |id|
    if id.is_a?(GameData::Ability)
      names.push(id.name)
      ids.push(id)
    else
      next unless GameData::Ability.exists?(id)
      abil = GameData::Ability.get(id)
      names.push(abil.name)
      ids.push(abil.id)
    end
  end
  return if names.empty?
  unless must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

def change_ability_choose_from_list(pkmn, ability_list)
  if ability_list.empty?
    pbMessage(_INTL("There aren't any abilities in the list!"))
    return false 
  end
  new_ability_data = pbChooseAbilityFromListEX(_INTL("Choose an ability."), ability_list)
  new_ability = new_ability_data[0]
  return false unless new_ability
  unless new_ability == pkmn.ability_id
    new_ability_name = GameData::Ability.get(new_ability).name
    if pbConfirmMessage(_INTL("Change {1}'s main ability to {2}?", pkmn.name, new_ability_name))
      pkmn.ability = new_ability
      pbMessage(_INTL("{1}'s main ability now is {2}.", pkmn.name, new_ability_name))
      return new_ability
    else
      return false
    end
  else
    pbMessage(_INTL("{1}'s main ability did't change.", pkmn.name))
    return false
  end
end

def pbChooseItemFromListEX(message, input_ids, must_choose = false)
  names = []
  ids   = []
  input_ids.each do |id|
    if id.is_a?(GameData::Item)
      names.push(id.name)
      ids.push(id)
    else
      next unless GameData::Item.exists?(id)
      item = GameData::Item.get(id)
      names.push(item.name)
      ids.push(item.id)
    end
  end
  return if names.empty?
  unless must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

def pbChooseMoveFromListEX(message, input_ids, must_choose = false)
  names = []
  ids  = []
  input_ids.each do |id|
    if id.is_a?(PokeBattle_Move)
      names.push(id.name)
      ids.push(id)
    else
      next unless GameData::Move.exists?(id)
      move = GameData::Move.get(id)
      names.push(move.name)
      ids.push(move.id)
    end
  end
  return if names.empty?
  unless must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

def guess_effective(off_type = nil) # to-do def_types
  # offensive
  if off_type
    offensive_type = GameData::Type.try_get(off_type)
    return unless offensive_type
    offensive_type_id = offensive_type.id
    offensive_type_name = offensive_type.name
  else
    offensive_type = select_from_all_types(auto: true)
    offensive_type_id, offensive_type_name = offensive_type
  end
  # defensive
  defensive_types = []
  defensive_types_id = []
  defensive_types_name = []
  defensive_types_amount = 1 + rand(3)
  defensive_types_amount.times do
    defensive_type = select_from_all_types(auto: true)
    next if defensive_types.include?(defensive_type)
    defensive_types << defensive_type
    defensive_types_id << defensive_type[0]
    defensive_types_name << defensive_type[1]
  end
  # calc_effective
  effective = Effectiveness.calculate(offensive_type_id, defensive_types_id[0], defensive_types_id[1], defensive_types_id[2]) / Effectiveness::NORMAL_EFFECTIVE.to_f

  effective_option = ["0", "0.125", "0.25", "0.5", "1", "2", "4", "8"]
  index = pbMessage(_INTL("Do you know the effectiveness?\n{1} => {2}", offensive_type_name, defensive_types_name.join(", ")), effective_option, -1)
  return if index == -1
  effective_choosen = effective_option[index].to_f

  if effective_choosen == effective
    pbMessage(_INTL("Congratulations, you got it right!"))
    return true
  else
    pbMessage(_INTL("Sorry, you got it wrong!"))
    return false
  end
end

def guess_pkmn_type(species_id = nil)
  if species_id
    species_data = GameData::Species.try_get(species_id)
    return unless species_data
  else
    random_species = GameData::Species.keys.sample
    species_data = GameData::Species.get(random_species)
  end

  species_id = species_data.id
  species_name = species_data.name
  species_types = species_data.types

  pbMessage(_INTL("Do you know the Type of {1}?", species_name))

  type_data = select_from_all_types(species_id)
  return unless type_data
  chosen_type_id, chosen_type_name = type_data

  if species_types.include?(chosen_type_id)
    pbMessage(_INTL("Congratulations, you got it right!\n{1}'s Type includes {2}!", species_name, chosen_type_name))
    return true
  else
    species_type_name = species_types.map { |species_type| GameData::Type.get(species_type).name }

    pbMessage(_INTL("Sorry, you got it wrong!\n{1}'s Type does not include {2}!", species_name, chosen_type_name))
    pbMessage(_INTL("{1}'s Type is {2}.", species_name, species_type_name.quick_join))
    return false
  end
end

def select_from_all_types(species_id = nil, auto: false)
  msg = _INTL("Which type do you want to choose?")
  if species_id
    species_name = GameData::Species.get(species_id).name
    msg = _INTL("Which type does {1} have?", species_name)
  end

  all_types_id = []
  all_types_name = []
  GameData::Type.each do |type|
    next if type.pseudo_type
    all_types_id << type.id
    all_types_name << type.name
  end

  if auto
    index = rand(all_types_id.size)
  else
    index = pbMessage(msg, all_types_name, -1)
    return if index == -1
  end

  chosen_type_id = all_types_id[index]
  chosen_type_name = all_types_name[index]
  return chosen_type_id, chosen_type_name
end

def random_choose_from_list(list_name, use_weight = true)
  selected_list = AllLists.const_get(list_name.to_s.upcase)
  return unless selected_list
  return selected_list.sample[:name] unless use_weight

  total_weight = selected_list.sum { |i| i[:weight] }
  random_value = rand(total_weight)
  current_weight = 0

  selected_list.each do |i|
    current_weight += i[:weight]
    return i[:name] if random_value < current_weight
  end
end

def calc_best_offense_types(target)
  offense_types = Hash.new { |hash, key| hash[key] = [] }
  defense_types = target.pbTypes(true)

  GameData::Type.each do |offense_type|
    next if offense_type.pseudo_type
    calc_type     = offense_type.id
    type_matchups = Array.new(3, Effectiveness::NORMAL_EFFECTIVE_ONE)

    defense_types.each_with_index do |defense_type, i|
      type_matchup     = Effectiveness.calculate_one(calc_type, defense_type)
      type_matchups[i] = type_matchup
    end

    effective = type_matchups.reduce(1, :*)
    next if Effectiveness.ineffective?(effective)
    offense_types[effective] << calc_type
  end
  #puts offense_types.inspect

  best_matchup = offense_types.keys.max
  offense_types[best_matchup]
end

def calc_best_offense_typeMod_types(move, user, target, consider_immunity = false, aiCheck = false)
  offense_types      = Hash.new { |hash, key| hash[key] = [] }
  old_move_calc_type = move.calcType

  GameData::Type.each do |offense_type|
    next if offense_type.pseudo_type
    calc_type     = offense_type.id
    move.calcType = calc_type
    typeMod       = aiCheck ? user.battle.battleAI.pbCalcTypeModAI_origin(calc_type, user, target, move) : move.pbCalcTypeMod(calc_type, user, target)
    next if Effectiveness.ineffective?(typeMod)
    next if consider_immunity && !user.pbSuccessCheckAgainstTarget(move, user, target, typeMod, false, aiCheck)
    offense_types[typeMod] << calc_type
  end
  #puts offense_types.inspect

  move.calcType = old_move_calc_type
  typeMod       = offense_types.keys.max
  calc_types    = offense_types[typeMod]
  [typeMod, calc_types]
end

def calc_best_offense_typeMod_types_damage(move, user, target, aiCheck = false) # AI doesn't use this
  calc_type_damage   = Hash.new { |hash, key| hash[key] = [] }
  old_move_calc_type = move.calcType

  GameData::Type.each do |offense_type|
    next if offense_type.pseudo_type
    type_id       = offense_type.id
    move.calcType = type_id
    typeMod       = aiCheck ? user.battle.battleAI.pbCalcTypeModAI_origin(type_id, user, target, move) : move.pbCalcTypeMod(type_id, user, target)
    next if Effectiveness.ineffective?(typeMod)
    next if !user.pbSuccessCheckAgainstTarget(move, user, target, typeMod, false, aiCheck)
    calc_damage = move.calculateDamageForHitAI(user, target, type_id, move.pbBaseDamage(move.baseDamage, user, target), move.pbTarget(user).num_targets)
    calc_type_damage[calc_damage] << [typeMod, type_id]
  end
  #puts calc_type_damage.inspect

  move.calcType   = old_move_calc_type
  max_damage      = calc_type_damage.keys.max
  max_damage_data = calc_type_damage[max_damage][0] # use the first max damage data
  [max_damage_data[0], [max_damage_data[1]]]
end

def calc_adaptive_ai_type_mod(battle, user, target, move, ability_id, consider_immunity = false, consider_damage = false)
  calc_data  = consider_damage ? calc_best_offense_typeMod_types_damage(move, user, target) : calc_best_offense_typeMod_types(move, user, target, consider_immunity)
  typeMod    = calc_data[0]
  calc_types = calc_data[1]
  change_calc_type(calc_types, battle, user, move, ability_id)
  typeMod
end

def change_calc_type(calc_types, battle, user, move, ability_id)
  old_move_calc_type = move.calcType
  if calc_types.include?(old_move_calc_type)
    old_move_calc_type
  else
    battle.pbShowAbilitySplash(user, ability_id)
    calc_type = calc_types[0] # use the first best type
    move.display_type_change_message(calc_type)
    move.calcType = calc_type
    battle.pbHideAbilitySplash(user)
    calc_type
  end
end

def generate_unique_id(digits = 8)
  random_ints = ("0".."9").to_a.sample(digits)
  random_letters = ("a".."z").to_a.sample(digits) + ("A".."Z").to_a.sample(digits)
  (random_ints + random_letters).shuffle!.join
end

def sort_bag
  $bag&.pockets.each { |pocket| pocket.sort_item! }
end

def get_pos(object_id, objct_class)
  case objct_class
  when :Ability
    get_abil_pos(object_id)
  when :Item
    get_item_pos(object_id)
  when :Move
    get_move_pos(object_id)
  when :Pokemon
    get_pkmn_pos(object_id)
  end
end

def get_abil_pos(abil)
  name = GameData::Ability.try_get(abil)&.real_name
  index = ABILITY_SEQUENCE.values.index(name)
  name && index ? index : 9999
end

def get_item_pos(item_id)
  name = GameData::Item.try_get(item_id)&.real_name
  index = ITEM_SEQUENCE.values.index(name)
  name && index ? index : 9999
end

def get_move_pos(move_id)
  name = GameData::Move.try_get(move_id)&.real_name
  index = MOVE_SEQUENCE.values.index(name)
  name && index ? index : 9999
end

def get_pkmn_pos(species)
  name = GameData::Species.try_get(species)&.real_name
  index = SPECIES_SEQUENCE.values.index(name)
  name && index ? index : 9999
end