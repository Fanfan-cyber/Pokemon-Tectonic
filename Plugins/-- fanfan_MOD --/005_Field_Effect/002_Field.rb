class PokeBattle_Battle::Field
  attr_reader :battle
  attr_reader :id, :name, :duration, :effects
  attr_reader :multipliers, :base_strengthened_message, :strengthened_message, :base_weakened_message, :weakened_message

  def initialize(battle)
    @battle                    = battle
    @effects                   = {}
    @base_strengthened_message = _INTL("The field strengthened the attack!")
    @base_weakened_message     = _INTL("The field weakened the attack!")

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
              @battle.pbDisplay(@base_strengthened_message)
            end
            @strengthened_message_displayed = true
          end
        elsif !@weakened_message_displayed
          if @weakened_message && !@weakened_message.empty?
            @battle.pbDisplay(@weakened_message)
          else
            @battle.pbDisplay(@base_weakened_message)
          end
          @weakened_message_displayed = true
        end
      end
      @strengthened_message_displayed = false
      @weakened_message_displayed = false
    }
  end

  def apply_field_effect(key, *args)
    return if is_base?
    @effects[key]&.call(*args)
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
end