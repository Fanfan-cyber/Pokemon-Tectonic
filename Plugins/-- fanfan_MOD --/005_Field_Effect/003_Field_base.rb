class PokeBattle_Battle::Field_base < PokeBattle_Battle::Field
  def initialize(battle, duration = -1, *args)
    super(battle)
    @id       = :Base
    @name     = _INTL("None")
    @duration = duration
  end
end