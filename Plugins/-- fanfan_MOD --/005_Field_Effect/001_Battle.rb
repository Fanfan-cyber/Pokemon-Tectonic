class PokeBattle_Battle
  attr_reader :stacked_fields 
  attr_reader :current_field

  alias field_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    field_initialize(scene, p1, p2, player, opponent)
    @stacked_fields = []
    create_new_field(:Base, begin_battle: true)

    create_new_field(:Electric)
  end

  def create_new_field(id, *args, begin_battle: false)
    formatted_name = id.to_s.downcase.gsub(/_/, '')
    field_class_name = "PokeBattle_Battle::Field_#{formatted_name}"
    return if !begin_battle && try_create_base_field?(field_class_name)
    return if !begin_battle && try_create_current_field?(field_class_name)

    return if !Object.const_defined?(field_class_name)
    new_field = Object.const_get(field_class_name).new(self, *args)

    remove_field(remove_all: true) if new_field.infinite?

    add_field(new_field)
    set_current_field(new_field)

    echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]") if !begin_battle
  end

  def try_create_base_field?(field_class_name)
    field_class_name == "PokeBattle_Battle::Field_base"
  end

  def try_create_current_field?(field_class_name)
    field_class_name == @current_field.class.to_s
  end

  def add_field(new_field)
    @stacked_fields.push(new_field)
  end

  def remove_field(remove_all: false)
    if remove_all
      @stacked_fields.keep_if(&:is_base?)
    else
      @stacked_fields.delete_if(&:end?)
    end
  end

  def set_current_field(new_field)
    @current_field = new_field
  end

  def apply_field_effect(key, *args, apply_all: false)
    if apply_all
      @stacked_fields.each { |field| field.apply_field_effect(key, *args) }
    else
      @current_field.apply_field_effect(key, *args)
    end
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

  def stacked_fields_name
    @stacked_fields.map(&:name)[1..-1].join(", ")
  end

  def stacked_fields_stat
    @stacked_fields.map { |field| [field.name, field.duration] }[1..-1].join(", ")
  end

  def has_field?
    @stacked_fields.length >= 2
  end

  def is_infinite_field?
    has_field? && @current_field.infinite?
  end

  def is_base_field?
    @current_field.is_base?
  end

  def is_electric_field?
    @current_field.is_electric?
  end

  def is_grassy_field?
    @current_field.is_grassy?
  end

  def is_misty_field?
    @current_field.is_misty?
  end

  def is_psychic_field?
    @current_field.is_psychic?
  end
end