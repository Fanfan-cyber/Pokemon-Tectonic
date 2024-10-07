class PokeBattle_Battle::Field_none < PokeBattle_Battle::Field
  def initialize(battle)
    super(battle)
    @id       = :None
    @name     = _INTL("None")
    @duration = -1
  end
end