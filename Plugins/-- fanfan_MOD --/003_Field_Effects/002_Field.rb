class PokeBattle_Battle::Field
  attr_reader :battle
  attr_reader :duration, :effects, :field_announcement, :fieldback, :id, :name   
  attr_reader :multipliers, :strengthened_message, :weakened_message
  attr_reader :nature_power_change, :secret_power_effect, :tailwind_duration, :inverse_battle
  attr_reader :creatable_field, :always_online

  DEFAULT_FIELD_DURATION  = 5
  FIELD_DURATION_EXPANDED = 3
  INFINITE_FIELD_DURATION = -1

  ACTIVATE_VARIETY_FIELD_SETTING   = false
  OPPOSING_ADVANTAGEOUS_TYPE_FIELD = true

  BASE_KEYS = %i[set_field_battler_universal].freeze

  PARADOX_KEYS = %i[begin_battle set_field_battle set_field_battler set_field_battler_universal
                   nature_power_change secret_power_effect tailwind_duration
                   end_field_battle end_field_battler].freeze

  DEFAULT_FIELD = {
    :Electric => [[],           # map ids
                %w[],           # trainer names
                %i[ELECTRIC]],  # advantageous types
    :Grassy   => [[],
                %w[],
                %i[GRASS]],
    :Misty    => [[],
                %w[],
                %i[FAIRY]],
    :Psychic  => [[],
                %w[],
                %i[PSYCHIC]],
    :Burning  => [[],
                %w[],
                %i[FIRE]],
    :Cursed   => [[],
                %w[],
                %i[GHOST]],
    :Sandy    => [[],
                %w[],
                %i[GROUND]],
    :Venomous => [[],
                %w[],
                %i[POISON]],
    :Ravine   => [[],
                %w[],
                %i[FLYING]],
    :Swamp    => [[],
                %w[],
                %i[WATER]],
    :Frozen   => [[],
                %w[],
                %i[ICE]],
  }.freeze

  @@field_data = {}
  def self.register(field, data)
    field = field.to_s.downcase.to_sym
    @@field_data[field] = data
    define_method("is_#{field}?") do # define is_xxx? Field instance method
      @id == field
    end
    PokeBattle_Battle.class_eval do # define is_xxx? Battle instance method
      define_method("is_#{field}?") do
        @current_field.public_send("is_#{field}?")
      end
    end
  end

  def self.field_data
    @@field_data
  end

  def self.print_field_effect_manual
    field_count = 0
    File.open("field_effect_manual.txt", "wb") do |file|
      @@field_data.each_value do |data|
        next unless data[:description]
        field_count += 1
        file.write("### Field #{field_count.to_digits}\r\n")
        file.write(data[:description])
        file.write("\r\n\r\n")
      end
      file.write("Total: #{field_count}")
    end
  end

  def initialize(battle)
    @battle                    = battle
    @duration                  = duration
    @effects                   = {}
    @field_announcement        = []
    @multipliers               = {}
    @base_strengthened_message = _INTL("The field strengthened the attack")
    @base_weakened_message     = _INTL("The field weakened the attack")
    @creatable_field           = []
    @always_online             = []

    @effects[:calc_damage] = proc { |user, target, numTargets, move, type, power, mults, aiCheck|
      @multipliers.each do |mult, calc_proc|
        next if mult[1] == 1.0
        ret = calc_proc&.call(user, target, numTargets, move, type, power, mults, aiCheck)
        next if !ret
        mults[mult[0]] *= mult[1]
        #echoln(mults)
        next if aiCheck
        multiplier = (mult[0] == :defense_multiplier) ? (1.0 / mult[1]) : mult[1]
        if mult[2] && !mult[2].empty?
          @battle.pbDisplay(mult[2])
        elsif multiplier > 1.0
          if !@strengthened_message_displayed
            if @strengthened_message && !@strengthened_message.empty?
              @battle.pbDisplay(@strengthened_message)
            else
              @battle.pbDisplay(_INTL("{1} on {2}!", @base_strengthened_message, target.pbThis(true)))
            end
            @strengthened_message_displayed = true
          end
        elsif !@weakened_message_displayed
          if @weakened_message && !@weakened_message.empty?
            @battle.pbDisplay(@weakened_message)
          else
            @battle.pbDisplay(_INTL("{1} on {2}!", @base_weakened_message, target.pbThis(true)))
          end
          @weakened_message_displayed = true
        end
      end
      @strengthened_message_displayed = false
      @weakened_message_displayed = false
     }

    @effects[:nature_power_change] = proc { |move| next @nature_power_change }

    @effects[:secret_power_effect] = proc { |user, targets, move| next @secret_power_effect }

    @effects[:set_field_battler_universal] = proc { |battler| battler.pbItemHPHealCheck }

    @effects[:tailwind_duration] = proc { |battler| next @tailwind_duration }

    @effects[:inverse_battle] = proc { next @inverse_battle }
  end

  def self.method_missing(method_name, *args, &block)
    echoln("Undefined class method #{method_name} is called with args: #{args.inspect}")
  end

  def method_missing(method_name, *args, &block)
    echoln("Undefined instance method #{method_name} is called with args: #{args.inspect}")
  end

  def apply_field_effect(key, *args)
    return if is_base? && !PokeBattle_Battle::Field::BASE_KEYS.include?(key)
    #echoln("[Field effect apply] #{@name}'s key #{key.upcase} applied!")
    @effects[key]&.call(*args)
  end

  def add_duration(amount = 0)
    return if infinite?
    @duration += amount
    #echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def reduce_duration(amount = 0)
    return if infinite?
    @duration -= amount
    #echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def set_duration(amount = 0)
    @duration = amount
    #echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def ==(another_field)
    @id == another_field.id
  end

  def is_on_top?
    self == @battle.top_field
  end

  def default_duration?
    @duration == 5
  end

  def infinite?
    @duration == -1
  end

  def end?
    @duration == 0
  end

  def is_field?(field)
    @id == field
  end

  def is_base?
    @id == :Base
  end
end