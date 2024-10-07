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