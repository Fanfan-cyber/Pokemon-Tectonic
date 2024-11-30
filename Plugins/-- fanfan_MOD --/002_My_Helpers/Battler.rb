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

  def should_apply_adaptive_ai_v4?
    hasActiveAbility?(:ADAPTIVEAIV4)
  end

  def should_apply_adaptive_ai_v3?
    hasActiveAbility?(:ADAPTIVEAIV3)
  end

  def should_apply_adaptive_ai_v2?
    hasActiveAbility?(:ADAPTIVEAIV2)
  end

  def should_apply_adaptive_ai_v1?
    hasActiveAbility?(:ADAPTIVEAIV1)
  end

  # Used by AI below
  def adaptive_ai_v1_type
    adaptive_ai_v1_type ||= {}
  end

  def adaptive_ai_v1_type_claced?(target)
    adaptive_ai_v1_type.key?(target.unique_id)
  end

  def get_adaptive_ai_v1_type(target)
    adaptive_ai_v1_type[target.unique_id]
  end

  def record_adaptive_ai_v1_type(target, type)
    adaptive_ai_v1_type[target.unique_id] = type
  end

  def adaptive_ai_v2_type
    adaptive_ai_v2_type ||= {}
  end

  def adaptive_ai_v2_type_claced?(target)
    adaptive_ai_v2_type.key?(target.unique_id)
  end

  def get_adaptive_ai_v2_type(target)
    adaptive_ai_v2_type[target.unique_id]
  end

  def record_adaptive_ai_v2_type(target, type)
    adaptive_ai_v2_type[target.unique_id] = type
  end

  def adaptive_ai_v3_type
    adaptive_ai_v3_type ||= {}
  end

  def adaptive_ai_v3_type_claced?(target)
    adaptive_ai_v3_type.key?(target.unique_id)
  end

  def get_adaptive_ai_v3_type(target)
    adaptive_ai_v3_type[target.unique_id]
  end

  def record_adaptive_ai_v3_type(target, type)
    adaptive_ai_v3_type[target.unique_id] = type
  end

  def adaptive_ai_v4_type
    adaptive_ai_v4_type ||= {}
  end

  def adaptive_ai_v4_type_claced?(target)
    adaptive_ai_v4_type.key?(target.unique_id)
  end

  def get_adaptive_ai_v4_type(target)
    adaptive_ai_v4_type[target.unique_id]
  end

  def record_adaptive_ai_v4_type(target, type)
    adaptive_ai_v4_type[target.unique_id] = type
  end

  def clear_adaptive_ai_data
    adaptive_ai_v1_type.clear
    adaptive_ai_v2_type.clear
    adaptive_ai_v3_type.clear
    adaptive_ai_v4_type.clear
  end
end