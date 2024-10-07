class PokeBattle_Battle
  attr_reader :stacked_fields 
  attr_reader :current_field

  alias field_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    field_initialize(scene, p1, p2, player, opponent)
    @stacked_fields = []
    create_new_field(:None, begin_battle: true)
    #create_new_field(:Electric)
  end

  def create_new_field(id, *args, begin_battle: false)
    formatted_name = id.to_s.downcase.gsub(/_/, '')
    field_class_name = "PokeBattle_Battle::Field_#{formatted_name}"
    return if !Object.const_defined?(field_class_name)

    new_field = Object.const_get(field_class_name).new(self, *args)
    return if !begin_battle && new_field.is_base?

    remove_field(true) if new_field.infinite?

    add_field(new_field)
    set_current_field(new_field)

    echoln("[Field set] #{new_field.name} was set! [#{stacked_fields_name}]") if !new_field.is_base?
  end

  def add_field(new_field)
    @stacked_fields.push(new_field)
  end

  def remove_field(remove_all = false)
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
    @stacked_fields.map(&:name).join(", ")
  end

  def has_field?
    @stacked_fields.length >= 2
  end

  def is_infinite_field?
    has_field? && @current_field.infinite?
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

class PokeBattle_Battle::Field
  attr_reader :battle
  attr_reader :id
  attr_reader :name
  attr_reader :duration
  attr_reader :effects

  def initialize(battle)
    @battle  = battle
    @effects = {}
  end

  def apply_field_effect(key, *args)
    @effects[key]&.call(*args)
  end

  def is_base?
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

  def infinite?
    @duration == -1
  end

  def end?
    @duration == 0
  end
end

class PokeBattle_Battle::Field_none < PokeBattle_Battle::Field
  def initialize(battle)
    super(battle)
    @id       = :None
    @name     = _INTL("None")
    @duration = -1
  end
end

class PokeBattle_Battle::Field_electric < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
  super(battle)
    @id       = :Electric
    @name     = _INTL("Electric Field")
    @duration = duration

    @effects[:begin_battle] = proc {
      @battle.pbDisplay(_INTL("场地上的气温骤降！"))
      @battle.pbStartWeather(nil, :Hail) if !@battle.primevalWeatherPresent?
    }

    @effects[:switch_in] = proc { |battler|
      buffable_stats = []
      GameData::Stat.each_battle do |stat|
        next if !battler.pbCanRaiseStatStep?(stat.id, battler)
        buffable_stats.push(stat.id)
      end
      next if buffable_stats.empty?
      if buffable_stats.length == 1
        msg = _INTL("场地上的电流随机增加了{1}的一项能力！", battler.pbThis)
      else
        msg = _INTL("场地上的电流随机增加了{1}的两项能力！", battler.pbThis)
      end
      @battle.pbDisplay(msg)
      stats_to_buff = buffable_stats.sample(2)
      anim = true
      stats_to_buff.each do |stat|
        battler.pbRaiseStatStep(stat, 1, battler, anim)
        anim = false
      end
    }

  end
end

class PokeBattle_Battle::Field_grassy < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
    @id       = :Grassy
    @name     = _INTL("Grassy Field")
    @duration = duration
  end
end

class PokeBattle_Battle::Field_misty < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
    @id       = :Misty
    @name     = _INTL("Misty Field")
    @duration = duration
  end
end

class PokeBattle_Battle::Field_psychic < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
    @id       = :Psychic
    @name     = _INTL("Psychic Field")
    @duration = duration
  end
end