def set_field(new_field = nil, duration = Battle::Field::INFINITE_FIELD_DURATION) # used for event
  $field = [new_field, duration]
end

def default_field
  $field
end

def clear_default_field
  $field = nil
end

def all_fields_data
  PokeBattle_Battle::Field.field_data
end

def all_fields
  PokeBattle_Battle::Field.field_data.keys
end

class PokeBattle_Battle
  attr_reader :stacked_fields # all field layers
  attr_reader :current_field  # the topmost field

  def initialize_field
    @stacked_fields = []
    create_base_field
  end

  def create_base_field
    create_new_field(:base, PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
  end

  def initialize_default_field
    set_default_field
    apply_field_effect(:begin_battle)
  end

  def set_test_field(test_field = :misty, duration = 10)
    create_new_field(test_field, duration)
  end

  def set_default_field
    if debugControl
      set_test_field
    elsif default_field
      field = create_new_field(default_field[0], default_field[1])
      clear_default_field # clear $field
      field
    elsif TA.get(:inversebattle)
      create_new_field(:inverse, PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
    elsif PokeBattle_Battle::Field::ACTIVATE_VARIETY_FIELD_SETTING
      apply_variety_field_setting
    end
  end

  def apply_variety_field_setting
    duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION
    trainer_battle = trainerBattle?
    if trainer_battle && (fields = suitable_trainer_fields).any?
      return create_new_field(fields.sample, duration)
    end
    if (fields = suitable_map_fields).any?
      return create_new_field(fields.sample, duration)
    end
    return unless PokeBattle_Battle::Field::OPPOSING_ADVANTAGEOUS_TYPE_FIELD
    apply_type_based_field(duration, trainer_battle)
  end

  def suitable_trainer_fields
    valid_fields = []
    opponent_names = @opponent.map(&:name)
    all_fields_data.each do |field, data|
      next if (data[:trainer_name] & opponent_names).empty?
      valid_fields << field
    end
    valid_fields
  end

  def suitable_map_fields
    valid_fields = []
    current_map_id = $game_map.map_id
    all_fields_data.each do |field, data|
      next unless data[:map_id].include?(current_map_id)
      valid_fields << field
    end
    valid_fields
  end

  def apply_type_based_field(duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION, trainer_battle = false)
    opposing_types = party2_able_pkmn_types.clone
    opposing_advantageous_types = trainer_battle ? opposing_types.most_elements : opposing_types
    type_fields = []
    all_fields_data.each do |field, data|
      next if (data[:edge_type] & opposing_advantageous_types).empty?
      type_fields << field
    end
    type_fields = all_fields if type_fields.empty?
    create_new_field(type_fields.sample, duration)
  end

  def can_create_field?(field_id)
    return true unless has_field?
    creatable_field = @current_field.creatable_field
    return true if creatable_field.empty?
    return creatable_field.include?(field_id)
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
        pbDisplay(_INTL("The field duration expanded to {1}!", field_duration))
      end
      return
    end

    return unless Object.const_defined?(field_class_name)
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

  # if you wanna some abilities/items/moves or something else to create a new field, use this method
  def create_new_field(field_id, duration = Battle::Field::DEFAULT_FIELD_DURATION, bg_change: true)
    return unless field_id
    return if try_create_zero_duration_field?(duration)
    formatted_field_id = field_id.to_s.downcase.to_sym
    return unless can_create_field?(formatted_field_id)
    field_class_name = "Battle::Field_#{formatted_field_id}"
    return if try_create_base_field?(field_class_name) && !can_create_base_field? # create Base only once
 
    # already exists a field, then try to create a new field
    if has_field? && try_create_current_field?(field_class_name) # new field is the same as the current field
      return if is_infinite?
      if try_create_infinite_field?(duration)
        remove_field(remove_all: true)
        set_field_duration(Battle::Field::INFINITE_FIELD_DURATION)
        add_field(@current_field)
        pbDisplay(_INTL("The field will exist forever!")) if Battle::Field::ANNOUNCE_FIELD_DURATION_INFINITE
        #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]")
      else
        expand_duration = Battle::Field::FIELD_DURATION_EXPANDED
        if duration > expand_duration # expand field duration
          add_field_duration(expand_duration)
        else
          add_field_duration(duration)
        end
        pbDisplay(_INTL("The field has already existed!")) if Battle::Field::ANNOUNCE_FIELD_EXISTED
        pbDisplay(_INTL("The field duration expanded to {1}!", field_duration)) if Battle::Field::ANNOUNCE_FIELD_DURATION_EXPAND
      end
      return
    end

    return unless Object.const_defined?(field_class_name)
    new_field = Object.const_get(field_class_name).new(self, duration) # create the new field

    removed_field = nil
    if has_field?
      end_field
      if try_create_infinite_field?(duration)
        remove_field(remove_all: true)
      else
        removed_field = remove_field(remove_field: new_field, ignore_infinite: false) # remove the same field in field layers
      end
    end

    add_field(new_field)
    set_current_field(new_field)
    add_field_duration(removed_field.duration) if removed_field # add the removed field duration

    # Base cant trigger
    if has_field?
      set_fieldback(bg_change)
      field_announcement(:start)
      #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]")
    end

    apply_field_effect(:set_field_battle)
    eachBattler { |battler| apply_field_effect(:set_field_battler_universal, battler) }
    eachBattler { |battler| apply_field_effect(:set_field_battler, battler) }

    return new_field
  end

  def end_of_round_field_process
    return unless has_field?
    apply_field_effect(:EOR_field_battle)
    eachBattler do |battler|
      apply_field_effect(:EOR_field_battler, battler)
      return if battler.owner_side_all_fainted? # end of battle
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

  def is_field?(field)
    @current_field.is_field?(field)
  end

  def is_base_field?
    @current_field.is_base?
  end

  def get_tailwind_duration(orig_turn = 4, user = nil)
    ret = apply_field_effect(:tailwind_duration, user)
    orig_turn += ret if ret
    orig_turn
  end
end

class PokeBattle_Battler
  def ground?(checkingForAI = false)
    return false if airborne?(checkingForAI)
    return false if semiInvulnerable_air?
    return true
  end

  def underground?
    return true if semiInvulnerable_underground?
    return false
  end

  def underunderwater?
    return true if semiInvulnerable_underwater?
    return false
  end

  def semiInvulnerable_air? # Same as inTwoTurnSkyAttack?
    return inTwoTurnAttack?("TwoTurnAttackInvulnerableInSky",
    "TwoTurnAttackInvulnerableInSkyNumbTarget",
    "TwoTurnAttackInvulnerableInSkyRecoilQuarterOfDamageDealt")
  end

  def semiInvulnerable_underground?
    return inTwoTurnAttack?("TwoTurnAttackInvulnerableUnderground")
  end

  def semiInvulnerable_underwater?
    return inTwoTurnAttack?("TwoTurnAttackInvulnerableUnderwater")
  end
end

class PokeBattle_Scene
  def set_fieldback(set_environment = false)
    if set_environment
      @sprites["battle_bg"].setBitmap(@original_battleBG)
      @sprites["base_0"].setBitmap(@original_playerBase)
      @sprites["base_1"].setBitmap(@original_enemyBase)
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