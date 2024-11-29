class PokeBattle_Move
  # 当技能的属性改变时显示信息
  def display_type_change_message(calc_type)
    type_name = GameData::Type.get(calc_type).name
    @battle.pbDisplay(_INTL("{1} change to {2} type!", @name, type_name))
  end
end