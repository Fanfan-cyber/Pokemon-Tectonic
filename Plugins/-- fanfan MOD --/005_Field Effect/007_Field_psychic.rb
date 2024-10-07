class PokeBattle_Battle::Field_psychic < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
    @id       = :Psychic
    @name     = _INTL("Psychic Field")
    @duration = duration
  end
end