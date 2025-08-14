class PokeBattle_Battle::Field
  attr_reader :battle, :id, :name, :duration, :effects, :field_announcement
  attr_reader :multipliers, :strengthened_message, :weakened_message
  attr_reader :modify_nature_power, :modify_secret_power_effect, :tailwind_duration, :inverse_battle
  attr_reader :creatable_field, :always_online

  DEFAULT_FIELD_DURATION  = 5
  FIELD_DURATION_EXPANDED = 3
  INFINITE_FIELD_DURATION = -1

  ACTIVATE_VARIETY_FIELD_SETTING   = false
  OPPOSING_ADVANTAGEOUS_TYPE_FIELD = true

  ANNOUNCE_FIELD_EXISTED           = true
  ANNOUNCE_FIELD_DURATION          = true
  ANNOUNCE_FIELD_DURATION_INFINITE = true
  ANNOUNCE_FIELD_DURATION_EXPAND   = true

  PARADOX_KEYS = %i[begin_battle set_field_battle set_field_battler set_field_battler_universal
                   modify_nature_power modify_secret_power_effect tailwind_duration inverse_battle
                   end_field_battle end_field_battler].freeze

  @@field_data = {}
  def self.register(field_id, data)
    define_method("is_#{field_id}?") { @id == field_id } # define is_xxx? Field instance method

    PokeBattle_Battle.class_eval do # define is_xxx? Battle instance method
      define_method("is_#{field_id}?") do
        @current_field.public_send("is_#{field_id}?")
      end
    end

    @@field_data[field_id] = data unless data[:special] # don't register special field
  end

  def self.field_data
    @@field_data
  end

  def self.print_field_effect_manual
    field_count = 0
    File.open("field_effect_manual.txt", "wb") do |file|
      @@field_data.each_value do |data|
        next unless data[:description] && !data[:description].empty?
        field_count += 1
        file.write("### Field #{field_count.to_digits}\r\n")
        file.write(data[:description])
        file.write("\r\n\r\n")
        data.delete(:description)
      end
      file.write("Total: #{field_count}")
    end
  end

  def initialize(battle, duration)
    @battle                    = battle
    @duration                  = duration
    @effects                   = {}
    @field_announcement        = {}
    @multipliers               = {}
    @base_strengthened_message = _INTL("The field strengthened the attack")
    @base_weakened_message     = _INTL("The field weakened the attack")
    @creatable_field           = []
    @always_online             = []

    @effects[:modify_damage] = proc { |user, target, numTargets, move, type, power, mults, aiCheck|
      @multipliers.each do |mult_data, calc_proc|
        mult = mult_data[1]
        next if mult == 1.0
        ret = calc_proc&.call(user, target, numTargets, move, type, power, mults, aiCheck)
        next unless ret
        mult_type = mult_data[0]
        mult_msg = mult_data[2]
        mults[mult_type] *= mult
        #echoln(mults)
        next if aiCheck
        multiplier = (mult_type == :defense_multiplier) ? (1.0 / mult) : mult
        if mult_msg && !mult_msg.empty?
          @battle.pbDisplay(mult_msg)
        elsif multiplier > 1.0
          unless @strengthened_message_displayed
            if @strengthened_message && !@strengthened_message.empty?
              @battle.pbDisplay(@strengthened_message)
            else
              @battle.pbDisplay(_INTL("{1} on {2}!", @base_strengthened_message, target.pbThis(true)))
            end
            @strengthened_message_displayed = true
          end
        else
          unless @weakened_message_displayed
            if @weakened_message && !@weakened_message.empty?
              @battle.pbDisplay(@weakened_message)
            else
              @battle.pbDisplay(_INTL("{1} on {2}!", @base_weakened_message, target.pbThis(true)))
            end
            @weakened_message_displayed = true
          end
        end
      end
      @strengthened_message_displayed = false
      @weakened_message_displayed = false
    }

    @effects[:end_field_battler_universal] = proc { |battler| battler.pbItemHPHealCheck }

    @effects[:modify_nature_power]        = proc { |_move                 | next @modify_nature_power }
    @effects[:modify_secret_power_effect] = proc { |_user, _targets, _move| next @modify_secret_power_effect }
    @effects[:tailwind_duration]          = proc { |_orig_turn, _user     | next @tailwind_duration }
    @effects[:inverse_battle]             = proc {                          next @inverse_battle }
    
    yield if block_given?
  end

  def self.method_missing(method_name, *args, &block)
    echoln("Undefined class method #{method_name} is called with args: #{args.inspect}")
  end

  def method_missing(method_name, *args, &block)
    echoln("Undefined instance method #{method_name} is called with args: #{args.inspect}")
  end

  def apply_field_effect(key, *args)
    return if is_base?
    #echoln("[Field effect apply] #{@name}'s key #{key.upcase} applied!")
    @effects[key]&.call(*args)
  end

  def add_duration(amount = 1)
    return if infinite?
    @duration += amount
    #echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def reduce_duration(amount = 1)
    return if infinite?
    @duration -= amount
    #echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def set_duration(amount = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    @duration = amount
    #echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def ==(another_field)
    @id == another_field.id
  end

  def top?
    self == @battle.top_field
  end

  def default_duration? # unsued
    @duration == PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION
  end

  def infinite?
    @duration == PokeBattle_Battle::Field::INFINITE_FIELD_DURATION
  end

  def end?
    @duration == 0
  end

  def is_field?(field_id)
    @id == field_id
  end
end