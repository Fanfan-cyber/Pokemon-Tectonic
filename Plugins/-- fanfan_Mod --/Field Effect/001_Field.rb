class Battle
  attr_reader :stacked_fields 
  attr_reader :current_field

  alias field_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    field_initialize(scene, p1, p2, player, opponent)
	@stacked_fields = []
	create_new_field(:None, true)
  end

  def add_field(new_field)
    @stacked_fields.push(new_field)
  end

  def remove_field(all = false)
    if all
	  @stacked_fields.keep_if(&:is_none?)
	else
	  @stacked_fields.delete_if(&:is_end?)
	end
  end

  def set_current_field(new_field)
    @current_field = new_field
  end

  def create_new_field(id, *args, start_battle = false)
    formatted_name = id.to_s.downcase.gsub(/_/, '')
    field_class_name = "Battle::Field_#{formatted_name}"
    return if !Object.const_defined?(field_class_name)

	new_field = Object.const_get(field_class_name).new(self, *args)
	return if !start_battle && new_field.is_none?

    remove_field(true) if new_field.is_infinite_duration?

	add_field(new_field)
	set_current_field(new_field)
  end

  def field_id
    @current_field.id
  end

  def field_name
    @current_field.name
  end

  def field_duration
    @current_field.duration
  end

  def has_field?
    @stacked_fields.length >= 2
  end

  def has_infinite_field?
    has_field? && @current_field.is_infinite_duration?
  end

  def has_electric_field?
    @current_field.is_electric?
  end

  def has_grassy_field?
    @current_field.is_grassy?
  end

  def has_misty_field?
    @current_field.is_misty?
  end

  def has_psychic_field?
    @current_field.is_psychic?
  end
end

class Battle::Field
  attr_reader :battle
  attr_reader :id
  attr_reader :name
  attr_reader :duration

  def initialize(battle)
    @battle = battle
  end

  def is_none?
    @id == :None
  end

  def is_electric?
    @id == :Electric
  end

  def is_grassy?
    @id == :Grassy
  end

  def is_misty?
    @id == :Misty
  end

  def is_psychic?
    @id == :Psychic
  end

  def is_default_duration?
    @duration == 5
  end

  def is_infinite_duration?
    @duration == -1
  end

  def is_end?
    @duration == 0
  end
end

class Battle::Field_none < Battle::Field
  def initialize(battle)
    super(battle)
	@id       = :None
	@name     = _INTL("None")
	@duration = -1
  end
end

class Battle::Field_electric < Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
	@id       = :Electric
	@name     = _INTL("Electric Field")
	@duration = duration
  end
end

class Battle::Field_grassy < Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
	@id       = :Grassy
	@name     = _INTL("Grassy Field")
	@duration = duration
  end
end

class Battle::Field_misty < Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
	@id       = :Misty
	@name     = _INTL("Misty Field")
	@duration = duration
  end
end

class Battle::Field_psychic < Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
	@id       = :Psychic
	@name     = _INTL("Psychic Field")
	@duration = duration
  end
end