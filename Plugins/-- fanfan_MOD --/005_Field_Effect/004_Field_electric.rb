class PokeBattle_Battle::Field_electric < PokeBattle_Battle::Field
  def initialize(battle, duration = 5, *args)
    super(battle)
    @id       = :Electric
    @name     = _INTL("Electric Field")
    @duration = duration

    @multipliers = {
      [:base_damage_multiplier, 1.5, _INTL("T-T-Tada!")] => proc { |user, target, numTargets, move, type, power, mults, aiCheck| 
        if user.pbOwnedByPlayer?
          next true
        end
        },
      [:attack_multiplier, 1.5] => proc { |user, target, numTargets, move, type, power, mults, aiCheck| },
      [:defense_multiplier, 10.5] => proc { |user, target, numTargets, move, type, power, mults, aiCheck| },
      [:final_damage_multiplier, 1.0]  => proc { |user, target, numTargets, move, type, power, mults, aiCheck| },
    }

=begin
    @effects[:begin_battle] = proc {
      @battle.pbDisplay(_INTL("场地上的气温骤降！"))
      @battle.pbStartWeather(nil, :Hail) if !@battle.primevalWeatherPresent?
    }

    @effects[:switch_in] = proc { |battler|
      buffable_stats = []
      GameData::Stat.each_battle do |stat|
        next if !battler.pbCanRaiseStatStep?(stat.id, battler)
        buffable_stats.push(stat.id)
      end
      next if buffable_stats.empty?
      if buffable_stats.length == 1
        msg = _INTL("场地上的电流随机增加了{1}的一项能力！", battler.pbThis)
      else
        msg = _INTL("场地上的电流随机增加了{1}的两项能力！", battler.pbThis)
      end
      @battle.pbDisplay(msg)
      stats_to_buff = buffable_stats.sample(2)
      anim = true
      stats_to_buff.each do |stat|
        battler.pbRaiseStatStep(stat, 1, battler, anim)
        anim = false
      end
    }
=end

  end
end