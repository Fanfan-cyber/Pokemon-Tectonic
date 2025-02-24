class Pokemon
  def regenerate_unique_id(digits = 8)
    @unique_id = generate_unique_id(digits)
  end

  def unique_id
    @unique_id ||= generate_unique_id
  end

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