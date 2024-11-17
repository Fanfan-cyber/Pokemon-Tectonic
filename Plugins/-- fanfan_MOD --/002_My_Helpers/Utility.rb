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
def export_plugin
  TA.write_all_plugins_in_txt
end

# 导出Plugin的代码
def export_plugin_ex
  TA.write_all_plugins
end

# 检查队伍是否有携带重复物品
def party_dup_item?
  $Trainer&.party_dup_item?
end

# 检查队伍中是否有某个精灵
def has_species_party?(species, form = -1)
  $Trainer.has_species?(species, form)
end

# 检查电脑中是否有某个精灵
def has_species_pc?(species, form = -1)
  pbEachNonEggPokemon do |pkmn, box|
    return true if pkmn.isSpecies?(species) && (form < 0 || pkmn.form == form)
  end
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
  return if battler&.fainted?
  abilis_pool = []
  GameData::Ability.each do |abil|
    next if abil.primeval || abil.cut
    next if abil.is_uncopyable_ability?
    next if battler&.abilities.include?(abil.id)
    abilis_pool.push(abil.id)
  end
  abilis_pool.sample
end

# 从物品列表中选择物品
def pbChooseItemFromListEX(message, input_ids, must_choose = false)
  names = []
  ids = []
  input_ids.each do |item_id|
    next if !GameData::Item.exists?(item_id)
    item = GameData::Item.get(item_id)
    names.push(item.name)
    ids.push(item.id)
  end
  return if names.empty?
  if !must_choose
    names.push(_INTL("Cancel"))
    ids.push(nil)
    ret = pbMessage(message, names, -1)
  else
    ret = pbMessage(message, names, 0)
  end
  ids[ret]
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