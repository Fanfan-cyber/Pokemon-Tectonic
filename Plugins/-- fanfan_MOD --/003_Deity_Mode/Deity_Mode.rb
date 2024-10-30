module Settings
  NO_TRIBE = false
  COPY_TRIBE = false
end

def deity?
  return false if !Settings::DEITY_Mode
  set_money
  true
end

def set_money
  $Trainer.money = Settings::MAX_MONEY
end

class PokeBattle_Battler
  alias deity_pbFaint pbFaint
  def pbFaint(show_messages = true)
    pbRecoverHP(@totalhp) if pbOwnedByPlayer? && deity?
    deity_pbFaint(show_messages)
  end

  alias deity_healing_reversed? healingReversed?
  def healingReversed?(show_messages = false)
    return false if pbOwnedByPlayer? && deity?
    deity_healing_reversed?(show_messages)
  end
  alias healing_reversed? healingReversed?

  alias deity_pbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(new_status, user, show_messages, move = nil, ignore_status = false)
    if pbOwnedByPlayer? && deity?
      @battle.pbDisplay(_INTL("It doesn't affect {1}!", pbThis(true))) if show_messages
      return false
    end
    deity_pbCanInflictStatus?(new_status, user, show_messages, move, ignore_status)
  end

  alias deity_pbReducePP pbReducePP
  def pbReducePP(move)
    return true if pbOwnedByPlayer? && deity?
    deity_pbReducePP(move)
  end
end

class PokeBattle_Battle
  alias deity_pbCaptureCalc pbCaptureCalc
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    return 4 if deity?
    deity_pbCaptureCalc(pkmn, battler, catch_rate, ball)
  end

  def pbUsePokeBallInBattle(item, idx_battler, user_battler)
    idx_battler = user_battler.index if idx_battler < 0
    battler = @battlers[idx_battler]
    if ItemHandlers.triggerUseInBattle(item, battler, self)
      @choices[user_battler.index][1] = nil if !deity? # Delete item from choice
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

  alias deity_update_tribe_count updateTribeCount
  def updateTribeCount
    deity_update_tribe_count
    add_all_tribe_bonus if @trainer.is_player? && deity?
    copy_player_tribe_bonus if @trainer.copy_tribes?
    romove_all_tribe_bonus if @trainer.tribe_disabled?
  end
  alias update_tribe_count updateTribeCount

  alias deity_has_any_tribe_overlap? hasAnyTribeOverlap?
  def hasAnyTribeOverlap?
    return false if deity?
    deity_has_any_tribe_overlap?
  end
  alias has_any_tribe_overlap? hasAnyTribeOverlap?
end