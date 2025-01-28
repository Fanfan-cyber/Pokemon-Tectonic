class Pokemon
  # 生成精灵的ID
  def regenerate_unique_id(digits = 8)
    @unique_id = generate_unique_id(digits)
  end

  # 精灵的ID
  def unique_id
    @unique_id ||= generate_unique_id
  end

  # 检查精灵是否是只有一种属性
  def mono_type?
    types.length < 2 
  end

  def match_criteria?(species: nil, form: 0, shiny: false)
    return @species == species.upcase && self.form == form && shiny? == shiny
  end

  def has_all_abils?
    TA.all_available_abilities.all? { |abil| abilities.include?(abil) }
  end
end