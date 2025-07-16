class PokeBattle_Battle::Field_base < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::INFINITE_FIELD_DURATION, *args)
    super(battle)
    @id       = :Base
    @name     = _INTL("Base")
    @duration = duration

=begin
    :accuracy_modify
    :base_type_change
    :begin_battle
    :block_berry
    :block_gem
    :block_heal
    :block_leftovers
    :block_move
    :calc_damage
    :calc_speed
    :end_field_battle
    :end_field_battler
    :end_of_move
    :end_of_move_universal
    :EOR_field_battle
    :EOR_field_battler
    :move_priority_change
    :move_second_type_on_calc
    :nature_power_change
    :no_charging
    :secret_power_effect
    :set_field_battle
    :set_field_battler
    :set_field_battler_universal
    :speed_modify
    :status_immunity
    :switch_in
    :tailwind_duration
    :target_expand
=end

  end
end