def set_field(new_field = nil)
  $field = new_field
end

def default_field
  $field
end

class PokeBattle_Battle
  attr_reader :stacked_fields 
  attr_reader :current_field

  alias field_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    field_initialize(scene, p1, p2, player, opponent)
    @stacked_fields = []
    create_base_field
  end

  def create_base_field
    create_new_field(:Base)
  end

  def set_default_field
    if default_field
      create_new_field(default_field, PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
      set_field
    else
      all_fields_data.each do |field, data| # trainer field
        next if !trainerBattle?
        trainer_field = @opponent.map(&:name) & data[1]
        next if trainer_field.empty?
        create_new_field(field, PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
        return
      end

      all_fields_data.each do |field, data| # map field
        next if !data[0].include?($game_map.map_id)
        create_new_field(field, PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
        return
      end

      return if !PokeBattle_Battle::Field::OPPOSING_ADVANTAGEOUS_TYPE_FIELD
      all_types = all_opposing_types.dup
      opposing_advantageous_types = trainerBattle? ? all_types.most_elements : all_types

      advantageous_fields = []
      all_fields_data.each do |field, data| # type field
        type_fields = opposing_advantageous_types & data[2]
        next if type_fields.empty?
        advantageous_fields << field
      end

      advantageous_fields = all_fields if advantageous_fields.empty?

      create_new_field(advantageous_fields.sample, PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
    end

    set_test_field if debugControl
  end

  def set_test_field
    create_new_field(:Psychic, 3)
  end

  def create_new_field(id, *args)
    duration = args[0]
    return if try_create_zero_duration_field?(duration)

    formatted_name = id.to_s.downcase.gsub(/_/, '')
    field_class_name = "PokeBattle_Battle::Field_#{formatted_name}"
    return if try_create_base_field?(field_class_name) && !can_create_base_field? 

    if has_field? && try_create_current_field?(field_class_name)
      return if is_infinite_field?
      if try_create_infinite_field?(args[0])
        remove_field(remove_all: true)
        set_field_duration(PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
        add_field(@current_field)
        pbDisplay(_INTL("The field will exist forever!"))
        #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]")
      else
        if duration && duration > PokeBattle_Battle::Field::FIELD_DURATION_EXPANDED
          add_field_duration(PokeBattle_Battle::Field::FIELD_DURATION_EXPANDED)
        else
          add_field_duration(duration || PokeBattle_Battle::Field::FIELD_DURATION_EXPANDED)
        end
        pbDisplay(_INTL("The field has already existed!"))
        pbDisplay(_INTL("The field duration expanded to #{field_duration}!"))
      end
      return
    end

    return if !Object.const_defined?(field_class_name)
    new_field = Object.const_get(field_class_name).new(self, *args)

    end_field if has_field?

    remove_field(remove_all: true) if try_create_infinite_field?(args[0])

    removed_field = remove_field(new_field, ignore_infinite: false)

    add_field(new_field)
    set_current_field(new_field)

    add_field_duration(removed_field.duration) if removed_field

    set_fieldback if has_field?
    field_announcement(:start) if has_field?
    #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]") if has_field?

    apply_field_effect(:set_field_battle)
    eachBattler { |battler| apply_field_effect(:set_field_battler_universal, battler) }
    eachBattler { |battler| apply_field_effect(:set_field_battler, battler) }
  end

  def end_of_round_field_process
    return if !has_field?
    apply_field_effect(:EOR_field_battle)
    eachBattler do |battler|
      apply_field_effect(:EOR_field_battler, battler)
      return if battler.ownerPartyAllFainted? # end of battle
    end

    field_duration_countdown
    remove_field

    end_field_process
  end

  def end_field_process
    if has_field?
      if is_top_field_activate?
        field_announcement(:continue)
      else
        end_field
        set_top_field
      end
    else
      end_field
      set_base_field
    end
  end

  def set_base_field
    set_current_field(base_field)
    set_fieldback

    apply_field_effect(:set_field_battle)
    eachBattler { |battler| apply_field_effect(:set_field_battler_universal, battler) }
    eachBattler { |battler| apply_field_effect(:set_field_battler, battler) }
  end

  def set_top_field
    set_current_field(top_field)
    set_fieldback
    field_announcement(:start)

    #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]") if has_field?

    apply_field_effect(:set_field_battle)
    eachBattler { |battler| apply_field_effect(:set_field_battler_universal, battler) }
    eachBattler { |battler| apply_field_effect(:set_field_battler, battler) }
  end

  def end_field
    field_announcement(:end)

    apply_field_effect(:end_field_battle)
    eachBattler { |battler| apply_field_effect(:end_field_battler, battler) }
  end

  def try_create_zero_duration_field?(duration)
    duration && duration == 0
  end

  def try_create_infinite_field?(duration)
    duration && duration == PokeBattle_Battle::Field::INFINITE_FIELD_DURATION
  end

  def can_create_base_field?
    @stacked_fields.empty?
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

  def add_field_duration(amount = 0)
    @current_field.add_duration(amount)
  end

  def reduce_field_duration(amount = 0)
    @current_field.reduce_duration(amount)
  end

  def set_field_duration(amount = 0)
    @current_field.set_duration(amount)
  end

  def field_duration_countdown
    @stacked_fields.each { |field| field.reduce_duration(1) if !field.infinite? }
  end

  def remove_field(remove_fields = nil, ignore_infinite: true, remove_all: false)
    return if !has_field?

    if remove_fields && ignore_infinite
      return @stacked_fields.delete_at(remove_fields) if remove_fields.is_a?(Integer)
      return @stacked_fields.delete(remove_fields)
    end

    removed_field = nil
    if remove_fields
      @stacked_fields.delete_if do |field|
        if !field.infinite? && field == remove_fields
          removed_field = field
          true
        end
      end
      return removed_field
    end

    if remove_all
      @stacked_fields.keep_if(&:is_base?)
      #echoln("[Field remove] All fields were removed!")
    else
      @stacked_fields.delete_if(&:end?)
      if stacked_fields_stat.empty?
        #echoln("[Field remove] All ended fields were removed!")
      else
        #echoln("[Field remove] All ended fields were removed! [#{stacked_fields_stat}]")
      end
    end
  end

  def set_current_field(new_field)
    @current_field = new_field
  end

  def end_current_field
    return if !has_field?
    remove_field(-1)
    end_field_process
  end

  def set_fieldback
    if has_field?
      @scene.set_fieldback
    else
      @scene.set_fieldback(true)
    end
  end

  def apply_field_effect(key, *args, apply_all: false)
    if apply_all
      @stacked_fields.each { |field| field.apply_field_effect(key, *args) if !PokeBattle_Battle::Field::PARADOX_KEYS.include?(key) }
    else
      @stacked_fields.each do |field|
        next if PokeBattle_Battle::Field::PARADOX_KEYS.include?(key)
        next if !field.always_online.include?(key)
        next if field.is_on_top?
        field.apply_field_effect(key, *args)
      end
      @current_field.apply_field_effect(key, *args)
    end
  end

  def field_announcement(announcement_type)
    case announcement_type
    when :start
    message = @current_field.field_announcement[0]
    pbDisplay(message) if message && !message.empty?
    if is_infinite_field?
      pbDisplay(_INTL("The field will exist forever!"))
    else
      pbDisplay(_INTL("The field will last for {1} more turns!", field_duration))
    end
    when :continue
    message = @current_field.field_announcement[1] || @current_field.field_announcement[0]
    pbDisplay(message) if message && !message.empty?
    pbDisplay(_INTL("The field will last for {1} more turns!", field_duration)) if !is_infinite_field?
    when :end
    message = @current_field.field_announcement[2]
    pbDisplay(message) if message && !message.empty?
    end
  end

  def all_fields
    PokeBattle_Battle::Field::DEFAULT_FIELD.keys
  end

  def all_fields_data
    PokeBattle_Battle::Field::DEFAULT_FIELD
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

  def base_field
    @stacked_fields[0]
  end

  def has_base_field?
    base_field && base_field.is_base?
  end

  def top_field
    @stacked_fields[-1]
  end

  def is_top_field_activate?
    @current_field == top_field
  end

  def has_field?
    @stacked_fields.length >= 2
  end
  alias has_top_field? has_field?

  def stacked_fields_name
    @stacked_fields.map(&:name)[1..-1].join(", ")
  end

  def stacked_fields_stat
    @stacked_fields.map { |field| [field.name, field.duration] }[1..-1].join(", ")
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

  def is_burning_field?
    @current_field.is_burning?
  end

  def is_cursed_field?
    @current_field.is_cursed?
  end

  def is_sandy_field?
    @current_field.is_sandy?
  end

  def is_venomous_field?
    @current_field.is_venomous?
  end

  def is_ravine?
    @current_field.is_ravine?
  end

  def is_swamp?
    @current_field.is_swamp?
  end

  def is_frozen_field?
    @current_field.is_frozen?
  end

  def all_own_types
    pbParty(0).map(&:types).flatten
  end

  def all_opposing_types
    pbParty(1).map(&:types).flatten
  end
end

class PokeBattle_Battler
  def on_ground?(checkingForAI = false)
    return false if airborne?(checkingForAI)
    return false if semiInvulnerable?
    return true
  end
end

class PokeBattle_Scene
  def set_fieldback(set_environment = false)
    if set_environment
      @sprites["battle_bg"].setBitmap(@environment_battleBG)
      @sprites["base_0"].setBitmap(@environment_playerBase)
      @sprites["base_1"].setBitmap(@environment_enemyBase)
    else
      field_name = @battle.current_field.fieldback
      return if !field_name || field_name.empty?
      root = "Graphics/Fieldbacks"
      battle_bg_path = "#{root}/#{field_name}_battlebg.png"
      return if !safeExists?(battle_bg_path)
      @sprites["battle_bg"].setBitmap(battle_bg_path)
      @sprites["base_0"].setBitmap("#{root}/#{field_name + "_playerbase.png"}")
      @sprites["base_1"].setBitmap("#{root}/#{field_name + "_enemybase.png"}")
    end
  end
end