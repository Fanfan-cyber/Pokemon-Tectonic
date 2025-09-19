def set_field(new_field = nil, duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION) # used for event
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
    apply_type_based_field
  end

  def suitable_trainer_fields
    valid_fields = []
    opponent_names = @opponent.map(&:name)
    all_fields_data.each do |field, data|
      next unless data[:trainer_name] && (data[:trainer_name] & opponent_names).any?
      valid_fields << field
    end
    valid_fields
  end

  def suitable_map_fields
    valid_fields = []
    current_map_id = $game_map.map_id
    all_fields_data.each do |field, data|
      next unless data[:map_id] && data[:map_id].include?(current_map_id)
      valid_fields << field
    end
    valid_fields
  end

  def apply_type_based_field(duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
    opposing_advantageous_types = party2_able_pkmn_types.most_elements
    type_fields = []
    all_fields_data.each do |field, data|
      next unless data[:edge_type] && (data[:edge_type] & opposing_advantageous_types).any?
      type_fields << field
    end
    type_fields = all_fields if type_fields.empty?
    create_new_field(type_fields.sample, duration)
  end

  def create_new_field(field_id, duration = Battle::Field::DEFAULT_FIELD_DURATION, transfer = false)
    return if try_create_zero_duration_field?(duration)
    formatted_field_id = field_id.to_s.downcase.to_sym
    field_class_name = "PokeBattle_Battle::Field_#{formatted_field_id}"
    return if try_create_base_field?(formatted_field_id) && !can_create_base_field? # create base only once
    return unless Object.const_defined?(field_class_name)

    # already exists fields, try to create a new field
    if has_field?
      if try_create_current_field?(formatted_field_id) # try to create the same field
        return if infinite_field? # return if already infinite
        if try_create_infinite_field?(duration) # try to create a infinite field
          remove_field(remove_all: true) # remove all fields from field layers, except base
          add_field(@current_field) # add field to field layers
          set_field_duration(duration)
          pbDisplay(_INTL("The field will exist forever!")) if PokeBattle_Battle::Field::ANNOUNCE_FIELD_DURATION_INFINITE
          #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]")
        else
          add_field_duration([duration, PokeBattle_Battle::Field::FIELD_DURATION_EXPANDED].min) # expand field duration
          pbDisplay(_INTL("The field has already existed!")) if PokeBattle_Battle::Field::ANNOUNCE_FIELD_EXISTED
          pbDisplay(_INTL("Its duration expanded to {1}!", field_duration)) if PokeBattle_Battle::Field::ANNOUNCE_FIELD_DURATION_EXPAND
        end
        return # return nil because actually it didn't create a new field
      else # try to create a different field

      end
    end

    # create new field
    return unless can_create_field?(formatted_field_id)

    end_current_field
    remove_field(-1) if transfer # transfer to another field, remove the current one

    new_field = Object.const_get(field_class_name).new(self, duration) # create the new field
    removed_field = remove_same_field(new_field, duration) # remove the same field

    # add the new field to field layers
    add_field(new_field)
    set_current_field(new_field)
    add_field_duration(removed_field.duration) if removed_field # add duration of the removed field 
    start_new_field
    new_field # return the new field
  end

  def remove_same_field(field, duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
    return unless has_field?
    removed_field = nil
    if try_create_infinite_field?(duration)
      remove_field(remove_all: true) # remove all fields from field layers, except base
    else
      removed_field = remove_field(field: field, ignore_infinite: false) # remove the same field in field layers
    end
    removed_field # return the removed field
  end

  def start_new_field
    return unless has_field?
    set_fieldback
    field_announcement(:start)
    #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]")

    field_set_effect
  end

  def end_current_field
    return unless has_field?
    field_announcement(:end)

    field_end_effect
  end

  def field_set_effect
    apply_field_effect(:set_field_battle)
    eachBattler { |battler| apply_field_effect(:set_field_battler_universal, battler) }
    eachBattler { |battler| apply_field_effect(:set_field_battler, battler) }
  end

  def field_end_effect
    apply_field_effect(:end_field_battle)
    eachBattler { |battler| apply_field_effect(:end_field_battler_universal, battler) }
    eachBattler { |battler| apply_field_effect(:end_field_battler, battler) }
  end

  def end_of_round_field_process
    return unless has_field?

    apply_field_effect(:EOR_field_battle)
    eachBattler do |battler|
      apply_field_effect(:EOR_field_battler, battler)
      return if battler.owner_side_all_fainted? # end of battle
    end

    field_duration_countdown
    remove_field # remove expired fields

    end_field_process
  end

  def end_field_process
    if has_field?
      if top_field_unchanged?
        field_announcement(:continue)
      else
        end_current_field
        set_top_field
      end
    else
      end_current_field
      set_base_field
    end
  end

  def set_base_field
    set_current_field(base_field)
    set_fieldback
    #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]")
  end

  def set_top_field
    set_current_field(top_field)
    set_fieldback
    field_announcement(:start)
    #echoln("[Field set] #{field_name} was set! [#{stacked_fields_stat}]") if has_field?

    field_set_effect
  end

  def remove_current_field # unused
    return unless can_remove_field?
    remove_field(-1)
    end_field_process
  end

  def can_remove_field?
    return false unless has_field?
    return true
  end

  def transfer_current_field(field_id, duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION) # unused
    return unless has_field?
    return unless can_create_field?(field_id)
    create_new_field(field_id, duration, true)
  end

  def can_create_field?(field_id) # to-do: expand this method
    return true unless has_field?
    creatable_field = @current_field.creatable_field
    return true if creatable_field.empty?
    return creatable_field.include?(field_id)
  end

  def remove_field(field: nil, ignore_infinite: true, remove_all: false)
    return unless has_field?

    if field.is_a?(Integer)
      return @stacked_fields.delete_at(field)
    elsif field.is_a?(PokeBattle_Battle::Field)
      if ignore_infinite
        return @stacked_fields.delete(field)
      else
        removed_field = nil
        @stacked_fields.delete_if do |f|
          if !f.infinite? && f == field
            removed_field = f
            true
          end
        end
        return removed_field
      end
    else
      if remove_all
        @stacked_fields.keep_if(&:is_base?)
        #echoln("[Field remove] All fields were removed!")
      else
        @stacked_fields.delete_if(&:end?)
=begin
        unless has_field?
          echoln("[Field remove] All ended fields were removed!")
        else
          echoln("[Field remove] All ended fields were removed! [#{stacked_fields_stat}]")
        end
=end
      end
    end
  end

  def field_announcement(type)
    message = @current_field.field_announcement[type]
    case type
    when :start
      pbDisplay(message) if message && !message.empty?
      if infinite_field?
        pbDisplay(_INTL("The field will exist forever!")) if PokeBattle_Battle::Field::ANNOUNCE_FIELD_DURATION_INFINITE
      else
        pbDisplay(_INTL("The field will last for {1} more turns!", field_duration)) if PokeBattle_Battle::Field::ANNOUNCE_FIELD_DURATION
      end
    when :continue
      message = @current_field.field_announcement[:start] if !message || message.empty?
      pbDisplay(message) if message && !message.empty?
      pbDisplay(_INTL("The field will last for {1} more turns!", field_duration)) if !infinite_field? && PokeBattle_Battle::Field::ANNOUNCE_FIELD_DURATION
    when :end
      pbDisplay(message) if message && !message.empty?
    end
  end

  def apply_field_effect(key, *args, apply_all: false)
    @stacked_fields.each do |field|
      next if field == @current_field # remove top field, same field only trigger once
      next if PokeBattle_Battle::Field::PARADOX_KEYS.include?(key) # only top field will trigger paradox keys
      next unless field.always_online.include?(key) || apply_all # always online keys always trigger
      field.apply_field_effect(key, *args)
    end
    @current_field.apply_field_effect(key, *args) # top field triggers
  end

  def try_create_zero_duration_field?(duration)
    duration == 0
  end

  def try_create_infinite_field?(duration)
    duration == PokeBattle_Battle::Field::INFINITE_FIELD_DURATION
  end

  def can_create_base_field?
    @stacked_fields.empty?
  end

  def try_create_base_field?(field_id)
    field_id == :base
  end

  def try_create_current_field?(field_id)
    field_id == @current_field.id
  end

  def has_base? # unused
    base_field&.is_base?
  end

  def has_field?
    @stacked_fields.length >= 2
  end
  alias has_top_field? has_field?
  alias existing_field? has_field?

  def infinite_field?
    has_field? && @current_field.infinite?
  end

  def top_field_unchanged?
    @current_field == top_field
  end

  # used for checking if a field is a specific field
  # you can use is_xxx? as well, for example is_electric?
  def is_field?(field_id)
    @current_field.is_field?(field_id)
  end

  def set_current_field(new_field)
    @current_field = new_field
  end

  def add_field(new_field)
    @stacked_fields.push(new_field)
  end

  def add_field_duration(amount = 1)
    @current_field.add_duration(amount)
  end

  def reduce_field_duration(amount = 1)
    @current_field.reduce_duration(amount)
  end

  def set_field_duration(amount = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    @current_field.set_duration(amount)
  end

  def field_duration_countdown
    @stacked_fields.each { |field| field.reduce_duration }
  end

  def set_fieldback
    @scene.set_fieldback(has_field?)
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

  def top_field
    @stacked_fields[-1]
  end

  def stacked_fields_name # unused
    @stacked_fields.map(&:name)[1..-1].join(", ")
  end

  def stacked_fields_stat
    @stacked_fields.map { |field| [field.name, field.duration] }[1..-1].join(", ")
  end

  def get_tailwind_duration(orig_turn = 4, user = nil)
    new_turn = applyEffectDurationModifiers(orig_turn, user)
    ret = apply_field_effect(:tailwind_duration, new_turn, user)
    new_turn += ret if ret
    new_turn
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

  def semiInvulnerable_air? # same as inTwoTurnSkyAttack?
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
  def set_fieldback(set_backdrop = false)
    unless set_backdrop
      @sprites["battle_bg"].setBitmap(@original_battleBG)
      @sprites["base_0"].setBitmap(@original_playerBase)
      @sprites["base_1"].setBitmap(@original_enemyBase)
    else
      field_id = @battle.field_id
      root = "Graphics/Fieldbacks"
      battle_bg  = "#{root}/#{field_id}_battlebg.png"
      playerbase = "#{root}/#{field_id}_playerbase.png"
      enemybase  = "#{root}/#{field_id}_enemybase.png"
      @sprites["battle_bg"].setBitmap(battle_bg) if FileTest.exist?(battle_bg)
      @sprites["base_0"].setBitmap(playerbase) if FileTest.exist?(playerbase)
      @sprites["base_1"].setBitmap(enemybase) if FileTest.exist?(enemybase)
    end
  end
end