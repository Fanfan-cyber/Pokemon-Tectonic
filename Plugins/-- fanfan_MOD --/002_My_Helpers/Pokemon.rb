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

  def attack_higher?
    @attack > @spatk
  end

  def attack_lower?
    @attack < @spatk
  end

  def attack_equal?
    @attack == @spatk
  end

  def defense_higher?
    @defense > @spdef
  end

  def move_matched?(move)
    move_data = GameData::Move.get(move)
    return true if move_data.adaptive? || attack_equal?
    return true if move_data.physical? && attack_higher?
    return true if move_data.special? && attack_lower?
    return false
  end
end