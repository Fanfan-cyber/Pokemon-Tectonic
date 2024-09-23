module Settings
  DIETY = true
end

def diety?
  Settings::DIETY
end

class PokeBattle_Battler
  alias fff_pbFaint pbFaint
  def pbFaint(showMessage = true)
    if pbOwnedByPlayer? && diety?
      pbRecoverHP(@totalhp)
	  #pbCureStatus
	end
    fff_pbFaint(showMessage)
  end

  alias fff_healingReversed? healingReversed?
  def healingReversed?(showMessages = false)
    return false if pbOwnedByPlayer? && diety?
    fff_healingReversed?(showMessages)
  end
end

class PokeBattle_Battle
  alias fff_pbCaptureCalc pbCaptureCalc
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    return 4 if diety?
    fff_pbCaptureCalc(pkmn, battler, catch_rate, ball)
  end
end