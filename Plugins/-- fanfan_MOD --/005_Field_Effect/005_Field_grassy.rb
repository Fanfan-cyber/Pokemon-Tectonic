class PokeBattle_Battle::Field_grassy < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
    @id       = :Grassy
    @name     = _INTL("Grassy Field")
    @duration = duration
  end
end