class PokeBattle_Battle::Field_icy < PokeBattle_Battle::Field
  def initialize(battle, duration = PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :icy
    @name                = _INTL("Icy")
    @nature_power_change = :ICEBEAM
    @mimicry_type        = :ICE
    @camouflage_type     = :ICE
    @ability_activation  = %i[ICEBODY SLUSHRUSH SNOWCLOAK]
    @terrain_pulse_type  = :ICE
    @shelter_type        = :ICE # halves damage taken from ice type moves after using shelter
    @field_announcement  = { :start => _INTL("The field is covered in ice."),
                             :end   => _INTL("The ice melted from the field!") }

    @multipliers = {
      [:power_multiplier, 1.5, _INTL("The cold strengthened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ICE].include?(type)
        next true if %i[BITTERMALICE].include?(move.id)
      },
      [:defense_multiplier, 1.3] => proc { |user, target, numTargets, move, type, power, mults|
        next true if target.pbHasType?(:ICE)
      },
      [:power_multiplier, 0.5, _INTL("The cold softened the attack...")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[FIRE].include?(type)
        next true if %i[SCALD STEAMERUPTION].include?(move.id)
      },
      [:power_multiplier, 1.3, _INTL("The ice melted away!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ERUPTION FIREPLEDGE FLAMEBURST HEATWAVE INCINERATE INFERNOOVERDRIVE LAVAPLUME MINDBLOWN RAGINGFURY SEARINGSHOT].include?(move.id)
      },
    }

    @effects[:base_type_change] = proc { |user, move, type|
      next :ICE if move.soundMove? && user.hasActiveAbility?(:LIQUIDVOICE)  # Sound type moves become Ice type from Liquid voice
    }

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
      next :ICE if %i[ROCK].include?(type) # Rock type moves have Ice sub-typing 
    }

    @effects[:end_of_move] = proc { |user, targets, move, numHits| # threr is no difference between this and :end_of_move_universal, just separate it for different uses
      if %i[BITTERMALICE].include?(move.id)
        targets.each do |target|
          next if target.damageState.unaffected || target.damageState.substitute
          next unless target.pbCanFreeze?(user, false, move)
          next unless @battle.pbRandom(100) < 10
          target.pbFreeze(_INTL("{1} was frozen by the pure malice!", target.pbThis))
        end
      end
      if %i[ERUPTION FIREPLEDGE FLAMEBURST HEATWAVE INCINERATE INFERNOOVERDRIVE LAVAPLUME MINDBLOWN RAGINGFURY SEARINGSHOT].include?(move.id)
        @battle.create_new_field(:cave, PokeBattle_Battle::Field::DEFAULT_FIELD_DURATION) # this line starts a new field
      end
    }

  end
end

PokeBattle_Battle::Field.register(:icy, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Burn damage is halved. #
# Refrigerate's power boost becomes 1.5x. #
# Aurora Veil can be activated regardless of weather. #
# Bulldoze, Earthquake, Fissure, Magnitude, and Tectonic Rage layer Spikes on both sides of the field if Water Surface or Murkwater Surface are not below the field. #
# The quake broke up the ice into spiky pieces!#
# Grounded Pokémon using any attacking physical-contact priority moves, Defense Curl, Lunge, Rollout, or Steamroller boost Speed by 1 stage. #
# [Pokémon] gained momentum on the ice! #
# Secret Power may inflict freeze. #

# Transitions to Other Fields
# Any move in this section inherently gains a 1.3x damage boost if it changes the field, unless noted otherwise.
#The following moves will transform this field into Cave. If Water Surface or Murkwater Surface are below this field, the field will transform to that instead.
# The field will transform into Water Surface if Scald is used 2 times, or Steam Eruption is used 1 time. If Cave is below this field, the field will transform to that instead.
#    Parts of the ice melted!
#    The hot water melted the ice!
#The following moves will transform this field into Water Surface or Murkwater Surface if either of those fields are below this field.
#    Bulldoze, Dive, Earthquake, Fissure, Magnitude, Tectonic Rage
#    The quake broke up the ice and revealed the water beneath!
#    The ice was broken from underneath!