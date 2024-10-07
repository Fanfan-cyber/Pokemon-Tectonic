module Settings
  NO_TRIBE = false
  COPY_TRIBE = false
end

def diety?
  return false if !Settings::DIETY_Mode
  set_money
  true
end

def set_money
  $Trainer.money = Settings::MAX_MONEY
end

class PokeBattle_Battler
  alias diety_pbFaint pbFaint
  def pbFaint(show_messages = true)
    pbRecoverHP(@totalhp) if pbOwnedByPlayer? && diety?
    diety_pbFaint(show_messages)
  end

  alias diety_healing_reversed? healingReversed?
  def healingReversed?(show_messages = false)
    return false if pbOwnedByPlayer? && diety?
    diety_healing_reversed?(show_messages)
  end
  alias healing_reversed? healingReversed?

  alias diety_pbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(new_status, user, show_messages, move = nil, ignore_status = false)
    return false if pbOwnedByPlayer? && diety?
    diety_pbCanInflictStatus?(new_status, user, show_messages, move, ignore_status)
  end

  alias diety_pbReducePP pbReducePP
  def pbReducePP(move)
    return true if pbOwnedByPlayer? && diety?
    diety_pbReducePP(move)
  end
end

class PokeBattle_Battle
  alias diety_pbCaptureCalc pbCaptureCalc
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    return 4 if diety?
    diety_pbCaptureCalc(pkmn, battler, catch_rate, ball)
  end

  def pbUsePokeBallInBattle(item, idx_battler, user_battler)
    idx_battler = user_battler.index if idx_battler < 0
    battler = @battlers[idx_battler]
    if ItemHandlers.triggerUseInBattle(item, battler, self)
      @choices[user_battler.index][1] = nil if !diety? # Delete item from choice
    elsif $PokemonBag&.pbCanStore?(item)
      $PokemonBag.pbStoreItem(item)
    else
      raise _INTL("Couldn't return unused item to Bag somehow.")
    end
  end
end
    

class Trainer
  def is_player?
    $Trainer == self
  end

  def tribe_disabled?
    Settings::NO_TRIBE
  end

  def copy_tribes?
    !is_player? && Settings::COPY_TRIBE
  end
end

class TribalBonus
  def add_tribe_bonus(tribe_id)
    @tribesGivingBonus << tribe_id if !@tribesGivingBonus.include?(tribe_id)
  end

  def add_all_tribe_bonus
    GameData::Tribe.each { |tribe_data| add_tribe_bonus(tribe_data.id) }
  end

  def romove_all_tribe_bonus
    @tribesGivingBonus.clear
  end

  def copy_player_tribe_bonus
    $Trainer.tribalBonus.tribesGivingBonus.each { |tribe_id| @tribesGivingBonus << tribe_id }
  end

  alias diety_update_tribe_count updateTribeCount
  def updateTribeCount
    diety_update_tribe_count
    add_all_tribe_bonus if @trainer.is_player? && diety?
	  copy_player_tribe_bonus if @trainer.copy_tribes?
	  romove_all_tribe_bonus if @trainer.tribe_disabled?
  end
  alias update_tribe_count updateTribeCount

  alias diety_has_any_tribe_overlap? hasAnyTribeOverlap?
  def hasAnyTribeOverlap?
    return false if diety?
    diety_has_any_tribe_overlap?
  end
  alias has_any_tribe_overlap? hasAnyTribeOverlap?
end