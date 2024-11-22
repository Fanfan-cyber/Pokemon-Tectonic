def game_start_tribe_update_trigger
  retuurn if !$DEBUG
  $Trainer&.romove_all_deity
  $Trainer&.add_deity(%i[power hp status pp catch tribe money]) # copy no_tribe
end

module Deity
  HUGE_POWER_RATIO = 10.0
end

class Player
  def money
    set_max_money if infinite_money?
    @money
  end

  def deity
    @deity ||= {}
  end

  def all_deity
    deity.keys
  end

  def add_deity(keys)
    keys = [keys] if !keys.is_a?(Array)
    keys.each { |key| deity[key] = true }
  end

  def remove_deity(keys)
    deity.remove(keys)
  end

  def romove_all_deity
    deity.clear
  end

  def has_deity?(key = nil)
    return deity.has?(key) if key
    deity.any?
  end

  def huge_power?
    deity[:power]
  end

  def infinite_hp?
    deity[:hp]
  end

  def immune_status?
    deity[:status]
  end

  def infinite_pp?
    deity[:pp]
  end

  def unconditional_catch?
    deity[:catch]
  end

  def all_tribe?
    deity[:tribe]
  end

  def copy_player_tribes?
    deity[:copy]
  end

  def no_tribe?
    deity[:no_tribe]
  end

  def infinite_money?
    deity[:money]
  end
end

class PokeBattle_Move
  alias deity_pbCalcDamageMultipliers pbCalcDamageMultipliers
  def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers, aiCheck = false)
    multipliers[:final_damage_multiplier] *= Deity::HUGE_POWER_RATIO if user.pbOwnedByPlayer? && $Trainer&.huge_power?
    deity_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers, aiCheck)
  end
end

class PokeBattle_Battler
  alias deity_pbFaint pbFaint
  def pbFaint(show_messages = true)
    pbRecoverHP(@totalhp) if pbOwnedByPlayer? && $Trainer&.infinite_hp?
    deity_pbFaint(show_messages)
  end

  alias deity_healing_reversed? healingReversed?
  def healingReversed?(show_messages = false)
    return false if pbOwnedByPlayer? && $Trainer&.infinite_hp?
    deity_healing_reversed?(show_messages)
  end
  alias healing_reversed? healingReversed?

  alias deity_pbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(new_status, user, show_messages, move = nil, ignore_status = false)
    if pbOwnedByPlayer? && $Trainer&.immune_status?
      @battle.pbDisplay(_INTL("{1} cannot have any status!", pbThis)) if show_messages
      return false
    end
    deity_pbCanInflictStatus?(new_status, user, show_messages, move, ignore_status)
  end

  alias deity_pbReducePP pbReducePP
  def pbReducePP(move)
    return true if pbOwnedByPlayer? && $Trainer&.infinite_pp?
    deity_pbReducePP(move)
  end
end

class PokeBattle_Battle
  alias deity_pbCaptureCalc pbCaptureCalc
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    return 4 if $Trainer&.unconditional_catch?
    deity_pbCaptureCalc(pkmn, battler, catch_rate, ball)
  end
end

class TribalBonus
  alias deity_update_tribe_count updateTribeCount
  def updateTribeCount
    game_start_tribe_update_trigger

    deity_update_tribe_count

    add_all_tribes if @trainer.is_player? && $Trainer&.all_tribe?
    copy_player_tribes if !@trainer.is_player? && $Trainer&.copy_player_tribes?
    romove_all_tribes if $Trainer&.no_tribe?
  end
  alias update_tribe_count updateTribeCount

  def add_tribe(tribe_ids)
    @tribesGivingBonus.add(tribe_ids, ignore: false)
  end

  def remove_tribe(tribe_ids)
    @tribesGivingBonus.remove(tribe_ids)
  end

  def add_all_tribes
    add_tribe(all_tribe_ids)
  end

  def romove_all_tribes
    @tribesGivingBonus.clear
  end

  def copy_player_tribes
    add_tribe(player_tribes)
  end

  def player_tribes
    $Trainer&.tribalBonus.tribesGivingBonus || []
  end

  def all_tribe_ids
    GameData::Tribe.all_id
  end
end