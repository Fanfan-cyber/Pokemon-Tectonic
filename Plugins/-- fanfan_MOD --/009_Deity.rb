module Deity
  HUGE_POWER_RATIO = 2.0
end

class Player
  def money
    set_max_money if TA.get(:maxmoney)
    @money
  end
end

class PokeBattle_Move
  alias deity_pbCalcDamageMultipliers pbCalcDamageMultipliers
  def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers, aiCheck = false)
    multipliers[:final_damage_multiplier] *= Deity::HUGE_POWER_RATIO if user.pbOwnedByPlayer? && TA.get(:hugepower)
    deity_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers, aiCheck)
  end

  alias deity_pbAdditionalEffectChance pbAdditionalEffectChance
  def pbAdditionalEffectChance(user, target, type, effectChance = 0, aiCheck = false)
    return 100 if user.pbOwnedByPlayer? && TA.get(:guaranteedeffects)
    deity_pbAdditionalEffectChance(user, target, type, effectChance, aiCheck)
  end

  alias deity_isRandomCrit? isRandomCrit?
  def isRandomCrit?(user, _target, rate)
    return true if user.pbOwnedByPlayer? && TA.get(:guaranteedcrit)
    deity_isRandomCrit?(user, _target, rate)
  end
end

class PokeBattle_Battler
  alias deity_pbFaint pbFaint
  def pbFaint(show_messages = true)
    pbRecoverHP(@totalhp) if pbOwnedByPlayer? && TA.get(:infinitehp)
    deity_pbFaint(show_messages)
  end

  alias deity_healing_reversed? healingReversed?
  def healingReversed?(show_messages = false)
    return false if pbOwnedByPlayer? && TA.get(:infinitehp)
    deity_healing_reversed?(show_messages)
  end

  alias deity_pbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(new_status, user, show_messages, move = nil, ignore_status = false)
    if pbOwnedByPlayer? && TA.get(:immunestatus)
      @battle.pbDisplay(_INTL("{1} cannot have any status!", pbThis)) if show_messages
      return false
    end
    deity_pbCanInflictStatus?(new_status, user, show_messages, move, ignore_status)
  end
end

class TribalBonus
  alias deity_update_tribe_count updateTribeCount
  def updateTribeCount
    deity_update_tribe_count
    add_all_tribes if @trainer.is_player? && TA.get(:alltribes)
    copy_player_tribes if !@trainer.is_player? && $Trainer && !TA.get(:notribecopy)
  end

  def add_tribe(tribe_ids)
    @tribesGivingBonus.add(tribe_ids, ignore: false)
  end

  def remove_tribe(tribe_ids)
    @tribesGivingBonus.remove(tribe_ids)
  end

  def add_all_tribes
    add_tribe(GameData::Tribe.all_id)
  end

  def copy_player_tribes
    add_tribe(player_tribes)
  end

  def player_tribes
    $Trainer&.tribalBonus.tribesGivingBonus || []
  end
end