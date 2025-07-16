class PokeBattle_Battle::Field_inverse < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :inverse
    @name               = _INTL("Inverse Field")
    @duration           = duration
    @fieldback          = "inverse"
    @inverse_battle     = true
    @field_announcement = [_INTL("!trats elttaB"),
                           _INTL(""),
                           _INTL("The field revover to normal!")]
  end
end