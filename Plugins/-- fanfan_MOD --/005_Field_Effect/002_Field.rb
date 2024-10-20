class PokeBattle_Battle::Field
  attr_reader :battle
  attr_reader :duration, :effects, :field_announcement, :fieldback, :id, :name   
  attr_reader :multipliers, :strengthened_message, :weakened_message
  attr_reader :nature_power_change, :secret_power_effect, :tailwind_duration
  attr_reader :always_online

  DEFAULT_FIELD_DURATION  = 5
  FIELD_DURATION_EXPANDED = 3
  INFINITE_FIELD_DURATION = -1

  OPPOSING_ADVANTAGE_TYPE_FIELD = true

  BASE_KEYS = %i[set_field_battler_universal]

  PARADOX_KEYS = %i[begin_battle set_field_battle set_field_battler set_field_battler_universal
                   nature_power_change secret_power_effect tailwind_duration
                   end_field_battle end_field_battler]

  DEFAULT_FIELD = {
    :Electric => [[],
                %w[],
                %i[ELECTRIC]],
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
  }

  def initialize(battle)
    @battle                    = battle
    @effects                   = {}
    @field_announcement        = []
    @multipliers               = {}
    @base_strengthened_message = _INTL("The field strengthened the attack")
    @base_weakened_message     = _INTL("The field weakened the attack")
    @always_online             = []

    @effects[:calc_damage] = proc { |user, target, numTargets, move, type, power, mults, aiCheck|
      @multipliers.each do |mult, calc_proc|
        next if mult[1] == 1.0
        ret = calc_proc&.call(user, target, numTargets, move, type, power, mults, aiCheck)
        next if !ret
        mults[mult[0]] *= mult[1]
        echoln(mults)
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

  end

  def apply_field_effect(key, *args)
    return if is_base? && !PokeBattle_Battle::Field::BASE_KEYS.include?(key)
    echoln("[Field effect apply] #{@name}'s key #{key.upcase} applied!")
    @effects[key]&.call(*args)
  end

  def add_duration(amount = 0)
    return if infinite?
    @duration += amount
    echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def reduce_duration(amount = 0)
    return if infinite?
    @duration -= amount
    echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
  end

  def set_duration(amount = 0)
    @duration = amount
    echoln("[Field duration change] #{@name}'s duration is now #{@duration}!")
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

  def is_base?
    @id == :Base
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

  def is_burning?
    @id == :Burning
  end

  def is_cursed?
    @id == :Cursed
  end

  def is_sandy?
    @id == :Sandy
  end

  def is_venomous?
    @id == :Venomous
  end

  def is_ravine?
    @id == :Ravine
  end

  def is_swamp?
    @id == :Swamp
  end

  def is_frozen?
    @id == :Frozen
  end
end