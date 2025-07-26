class PokeBattle_Battle::Field_inverse < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super(battle)
    @id                 = :inverse
    @name               = _INTL("Inverse Field")
    @duration           = duration
    @fieldback          = "inverse"
    @inverse_battle     = true
    @field_announcement = { :start    => _INTL("!trats elttaB"),
                            :contiune => _INTL(""),
                            :end      => _INTL("The field recovered to normal!") }
  end
end