class PokeBattle_Battle::Field_inverse < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION, *args)
    super
    @id                 = :inverse
    @name               = _INTL("Inverse Field")
    @inverse_battle     = true
    @field_announcement = { :start    => _INTL("!trats elttaB"),
                            :contiune => _INTL(""),
                            :end      => _INTL("The field recovered to normal!") }
  end
end

PokeBattle_Battle::Field.register(:inverse, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
  :description  => <<-DESC
#-------------------- 反转场地 / Inverse Field [IF] --------------------#
# 属性克制发生发转
DESC
})