module Settings
  DIETY = true
  NO_TRIBE = false
end

def diety?
  Settings::DIETY
end

class PokeBattle_Battler
  alias diety_pbFaint pbFaint
  def pbFaint(show_messages = true)
    if pbOwnedByPlayer? && diety?
      pbRecoverHP(@totalhp)
      pbCureStatus
    end
    diety_pbFaint(show_messages)
  end

  alias diety_healingReversed? healingReversed?
  def healingReversed?(show_messages = false)
    return false if pbOwnedByPlayer? && diety?
    diety_healingReversed?(show_messages)
  end
end

class PokeBattle_Battle
  alias diety_pbCaptureCalc pbCaptureCalc
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    return 4 if diety?
    diety_pbCaptureCalc(pkmn, battler, catch_rate, ball)
  end
end

class Trainer
  def is_player?
    self == $Trainer
  end

  def tribe_disabled?
    Settings::NO_TRIBE
  end
end

class TribalBonus
  def update_tribe_bonus(tribe_id)
    @tribesGivingBonus.push(tribe_id) if !@tribesGivingBonus.include?(tribe_id)
  end

  def add_all_tribe_bonus
    GameData::Tribe.each { |tribe_data| update_tribe_bonus(tribe_data.id) }
  end

  def romove_all_tribe_bonus
    @tribesGivingBonus.clear
  end

  alias diety_updateTribeCount updateTribeCount
  def updateTribeCount
    diety_updateTribeCount
    add_all_tribe_bonus if @trainer.is_player? && diety?
    romove_all_tribe_bonus if @trainer.tribe_disabled?
  end

  alias diety_hasAnyTribeOverlap? hasAnyTribeOverlap?
  def hasAnyTribeOverlap?
    return false if diety?
    diety_hasAnyTribeOverlap?
  end
end