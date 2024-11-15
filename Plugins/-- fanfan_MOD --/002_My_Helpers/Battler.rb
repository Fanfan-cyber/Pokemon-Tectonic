class PokeBattle_Battler
  # 从特性库中随机添加一个特性
  def add_random_ability(showcase = false)
    added_abil = choose_random_ability(self)
    addAbility(added_abil, showcase)
  end
end