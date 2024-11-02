# 获取TA的某个变量值
def get_ta(var)
  $Trainer&.get_ta(var)
end

# 设置TA的某个变量的值
def set_ta(var, value)
  $Trainer&.set_ta(var, value)
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