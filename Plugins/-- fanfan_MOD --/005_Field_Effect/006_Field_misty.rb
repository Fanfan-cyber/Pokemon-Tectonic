class PokeBattle_Battle::Field_misty < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
    @id       = :Misty
    @name     = _INTL("Misty Field")
    @duration = duration
  end
end