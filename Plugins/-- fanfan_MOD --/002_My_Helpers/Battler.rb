class PokeBattle_Battler
  # 为精灵从特性库中随机添加一个特性
  def add_random_ability(showcase = false, trigger = true)
    return if fainted?
    added_abil = choose_random_ability(self)
    addAbility(added_abil, showcase, trigger)
  end

  # 精灵的ID
  def unique_id
    @pokemon.unique_id
  end

  # 检查精灵所在的一方是否已经全部濒死
  def owner_side_all_fainted?
    @battle.pbParty(@index).all?(&:fainted?)
  end

  def should_apply_adaptive_ai_v4?(target, move)
    hasActiveAbility?(:ADAPTIVEAIV4) && move.damagingMove?
  end

  def should_apply_adaptive_ai_v3?(target, move)
    hasActiveAbility?([:ADAPTIVEAIV3, :ADAPTIVEAIV4]) && move.damagingMove?
  end

  def should_apply_adaptive_ai_v2?(target, move)
    hasActiveAbility?(:ADAPTIVEAIV2) && move.damagingMove?
  end

  def should_apply_adaptive_ai_v1?(target, move)
    hasActiveAbility?(:ADAPTIVEAIV1) && move.damagingMove?
  end

  # 检查精灵是否可以在Pre Switch阶段行动
  def has_pre_free_switch?
    #return true if !pbOwnedByPlayer?
    return false
  end
end