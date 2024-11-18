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
  def owner_party_all_fainted?
    @battle.pbParty(@index).all?(&:fainted?)
  end
end