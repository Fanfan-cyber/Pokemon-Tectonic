# 获取TA的某个变量值
def get_ta(var)
  $Trainer&.get_ta(var)
end

# 设置TA的某个变量的值
def set_ta(var, value)
  $Trainer&.set_ta(var, value)
end

# 导出技能的动画列表
def export_anim_list
  TA.export_move_anim_list
end

# 导出Script的代码到txt
def export_script
  TA.write_all_scripts_in_txt
end

# 导出Plugin的代码到txt
def export_plugin(encrypted = false)
  TA.write_all_plugins_in_txt(encrypted)
end

# 导出Plugin的代码
def export_plugin_ex(encrypted = false)
  TA.write_all_plugins(encrypted)
end

# 获取当前游戏使用的语言
def get_language
  Settings::LANGUAGES[$PokemonSystem.language || 0][0]
end

# 检查游戏当前使用的语言是否为简体中文
def is_chinese?
  Settings::LANGUAGES[$PokemonSystem.language || 0][0] == "Simplified Chinese"
end

# 检查队伍是否有携带重复物品
def party_dup_item?
  $Trainer&.party_dup_item?
end

# 检查队伍中是否有某个精灵
def has_species_party?(species, form = -1)
  $Trainer&.has_species?(species, form)
end

# 检查电脑中是否有某个精灵
def has_species_pc?(species, form = -1)
  pbEachPokemon do |pkmn, _box|
    return true if pkmn.isSpecies?(species) && (form < 0 || pkmn.form == form)
  end
  return false
end

# 检查队伍和电脑中是否有某个精灵
def has_species?(species, form = -1)
  has_species_party?(species, form) || has_species_pc?(species, form)
end

# 获取队伍中某只精灵的索引
def pbGetPartyIndex(species, form = 0)
  $Trainer&.pbGetPartyIndex(species, form)
end

# 获取队伍中的某只精灵
def pbGetPartyPokemon(index)
  $Trainer&.party[index]
end

# 把队伍中的某只精灵移动到另一个位置
def pbSwapPartyPosition(species, new_index = 0, form = 0)
  $Trainer&.pbSwapPartyPosition(species, new_index, form)
end

# 从特性库中随机选择一个特性
def choose_random_ability(battler = nil)
  return if battler && battler.fainted?
  abilis_pool = []
  GameData::Ability.each do |abil|
    next if abil.primeval || abil.cut
    next if abil.is_test?
    next if abil.is_uncopyable_ability?
    next if battler && battler.abilities.include?(abil.id)
    abilis_pool.push(abil.id)
  end
  abilis_pool.sample
end

# 从玩家队伍的所有物种特性中随机选择一个特性
def choose_random_ability_from_player(battler = nil)
  return if battler && battler.fainted?
  abilis_pool = []
  $Trainer.each_pkmn do |pkmn|
    pkmn.species_abilities.each do |abil_id|
      abil = GameData::Ability.get(abil_id)
      next if abil.primeval || abil.cut
      next if abil.is_test?
      next if abil.is_uncopyable_ability?
      next if battler && battler.abilities.include?(abil_id)
      abilis_pool.push(abil_id)
    end
  end
  abilis_pool.sample
end

# 从精灵列表中选择精灵
def pbChoosePkmnFromListEX(message, input_ids, must_choose = false)
  names = []
  ids = []
  input_ids.each do |id|
    if id.is_a?(Pokemon)
      names.push(id.name)
      ids.push(id)
    else
      next if !GameData::Pokemon.exists?(id)
      pkmn = GameData::Pokemon.get(id)
      names.push(pkmn.name)
      ids.push(pkmn.id)
    end
  end
  return if names.empty?
  if !must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

# 从特性列表中选择特性
def pbChooseAbilityFromListEX(message, input_ids, must_choose = false)
  names = []
  ids = []
  input_ids.each do |id|
    if id.is_a?(GameData::Ability)
      names.push(id.name)
      ids.push(id)
    else
      next if !GameData::Ability.exists?(id)
      abil = GameData::Ability.get(id)
      names.push(abil.name)
      ids.push(abil.id)
    end
  end
  return if names.empty?
  if !must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

def change_ability_choose_from_list(pkmn, ability_list)
  new_ability_data = pbChooseAbilityFromListEX(_INTL("Choose an ability."), ability_list)
  new_ability = new_ability_data[0]
  return false if !new_ability
  if new_ability != pkmn.ability_id
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

# 从物品列表中选择物品
def pbChooseItemFromListEX(message, input_ids, must_choose = false)
  names = []
  ids = []
  input_ids.each do |id|
    if id.is_a?(GameData::Item)
      names.push(id.name)
      ids.push(id)
    else
      next if !GameData::Item.exists?(id)
      item = GameData::Item.get(id)
      names.push(item.name)
      ids.push(item.id)
    end
  end
  return if names.empty?
  if !must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

# 从技能列表中选择物品
def pbChooseMoveFromListEX(message, input_ids, must_choose = false)
  names = []
  ids = []
  input_ids.each do |id|
    if id.is_a?(PokeBattle_Move)
      names.push(id.name)
      ids.push(id)
    else
      next if !GameData::Move.exists?(id)
      move = GameData::Move.get(id)
      names.push(move.name)
      ids.push(move.id)
    end
  end
  return if names.empty?
  if !must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  return ids[ret], ret, names[ret]
end

# 猜某一个精灵的属性
def guess_pkmn_type(species_id = nil)
  if species_id
    species_data = GameData::Species.try_get(species_id)
    return if !species_data
  else
    random_species = GameData::Species.keys.sample
    species_data = GameData::Species.get(random_species)
  end

  species_id = species_data.id
  species_name = species_data.name
  species_types = species_data.types

  pbMessage(_INTL("Do you know the Type of {1}?", species_name))

  type_data = select_from_all_types(species_id)
  return if !type_data
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

# 从全属性中选择一个属性
def select_from_all_types(species_id = nil)
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

  index = pbMessage(msg, all_types_name, -1)
  return if index == -1

  chosen_type_id = all_types_id[index]
  chosen_type_name = all_types_name[index]

  return chosen_type_id, chosen_type_name
end

# 从物品列表中随机选择一个物品
def random_choose_from_list(list_name, use_weight = true)
  selected_list = AllLists.const_get(list_name.to_s.upcase)
  return if !selected_list
  return selected_list.sample[:name] if !use_weight

  total_weight = selected_list.sum { |i| i[:weight] }
  random_value = rand(total_weight)
  current_weight = 0

  selected_list.each do |i|
    current_weight += i[:weight]
    return i[:name] if random_value < current_weight
  end
end

# 计算最好的进攻属性
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

# 生成一个独特的ID
def generate_unique_id(digits = 8)
  random_ints = ("0".."9").to_a.sample(digits)
  random_letters = ("a".."z").to_a.sample(digits) + ("A".."Z").to_a.sample(digits)
  (random_ints + random_letters).shuffle!.join
end

# 按照中文重新排序背包的所有口袋
def sort_bag
  $bag&.pockets.each { |pocket| pocket.sort_item! }
end

# 获取某个对象在中文序列中的位置
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

# 获取某个特性在中文序列中的位置
def get_abil_pos(abil)
  name = GameData::Ability.try_get(abil)&.real_name
  index = ABILITY_SEQUENCE.values.index(name)
  name && index ? index : 9999
end

# 获取某个物品在中文序列中的位置
def get_item_pos(item_id)
  name = GameData::Item.try_get(item_id)&.real_name
  index = ITEM_SEQUENCE.values.index(name)
  name && index ? index : 9999
end

# 获取某个技能在中文序列中的位置
def get_move_pos(move_id)
  name = GameData::Move.try_get(move_id)&.real_name
  index = MOVE_SEQUENCE.values.index(name)
  name && index ? index : 9999
end

# 获取某个精灵物种在中文序列中的位置
def get_pkmn_pos(species)
  name = GameData::Species.try_get(species)&.real_name
  index = SPECIES_SEQUENCE.values.index(name)
  name && index ? index : 9999
end