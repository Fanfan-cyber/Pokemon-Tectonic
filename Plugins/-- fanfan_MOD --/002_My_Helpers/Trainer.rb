class Trainer
  attr_reader :is_player

  # 检查当前训练师是否是玩家
  def is_player?
    is_player
  end

  # 检查队伍中是否有精灵
  def has_pokemon?
    @party.length >= 1
  end

  # 遍历每一只精灵
  def each_pkmn
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && !pkmn.egg? }
  end

  # 遍历每一只没有濒死的精灵
  def each_able_pkmn
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && !pkmn.egg? && !pkmn.fainted? }
  end

  # 遍历每一只濒死的精灵
  def each_fainted_pkmn
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && !pkmn.egg? && pkmn.fainted? }
  end

  # 检查队伍里是否有濒死的精灵
  def has_fainted_pkmn?
    pokemon_party.any?(&:fainted?)
  end

  # 遍历每一个精灵蛋
  def each_egg
    @party.each_with_index { |pkmn, index| yield pkmn, index if pkmn && pkmn.egg? }
  end

  # 获取队伍中的最高等级
  def party_highest_level
    able_party.map(&:level).max
  end

  # 获取队伍中的最低等级
  def party_lowest_level
    able_party.map(&:level).min
  end

  # 随机获取一只队伍里的精灵
  def party_random_pkmn(able = true, pkmn_clone = false)
    pkmn = able ? able_party.sample : pokemon_party.sample
    pkmn_clone ? pkmn.clone_pkmn : pkmn
  end

  # 获取队伍中所有精灵携带的物品
  def party_items
    @party.map(&:items).flatten.compact
  end

  # 检查队伍是否有携带重复物品
  def party_dup_item?
    party_items.dup?
  end

  # 检查队伍中是否已经有精灵携带了某个物品
  def party_already_item?(item)
    party_items.include?(item)
  end

  # 获取队伍中所有精灵的异常状态
  def party_statuses
    @party.map(&:status).delete_if { |status| status == :NONE }
  end

  # 检查队伍中的精灵是否有重复的异常状态
  def party_dup_status?
    party_statuses.dup?
  end

  # 检查队伍中是否已经有精灵有某个异常状态
  def party_already_status?(status)
    party_statuses.include?(status)
  end

  # 获取队伍中某只精灵的索引
  def pbGetPartyIndex(species, form = 0)
    each_pkmn { |pkmn, index| return index if pkmn.isSpecies?(species) && pkmn.form == form }
  end

  # 把队伍中的某只精灵移动到某一个位置
  def pbSwapPartyPosition(species, new_index = 0, form = 0)
    old_index = pbGetPartyIndex(species, form)
    return if !old_index || old_index == new_index
    @party.swap!(old_index, new_index)
  end
end