class PokeBattle_Battle::Field_base < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION)
    super
    @id   = :base
    @name = _INTL("Base")
  end
end

PokeBattle_Battle::Field.register(:base, {
  :special      => true,
  :trainer_name => [],
  :map_id       => [],
  :edge_type    => [],
  :description  => ""
})

=begin
    :add_move_second_type
    :begin_battle
    :block_berry
    :block_gem
    :block_heal
    :block_leftovers
    :end_field_battle
    :end_field_battler
    :end_field_battler_universal
    :end_of_move
    :end_of_move_universal
    :EOR_field_battle
    :EOR_field_battler
    :modify_accuracy
    :modify_damage
    :modify_move_base_type
    :modify_nature_power
    :modify_priority
    :modify_secret_power_effect
    :modify_speed
    :modify_speed_2
    :no_charging
    :set_field_battle
    :set_field_battler
    :set_field_battler_universal
    :spread_move_target
    :status_immunity
    :switch_in
    :tailwind_duration

    # to-do
    :block_move
    :no_recharging
    :change_effectiveness
    :block_weather
=end