SPEEDUP_STAGES = [1, 2]
$GameSpeed = 0
$frame = 0
$CanToggle = true

def pbAllowSpeedup
  $CanToggle = true
end

def pbDisallowSpeedup
  $CanToggle = false
end

def get_version_name
  is_chinese? ? VERSION_NAME[1] : VERSION_NAME[0]
end

module Input
  class << self
    alias fast_forward_update update
  end

  def self.update
    fast_forward_update
    pbSetWindowText("#{System.game_title} | #{get_version_name}")
    if $CanToggle && MInput.trigger?(Settings::FAST_FORWARD_KEY)
      $GameSpeed += 1
      $GameSpeed = 0 if $GameSpeed >= SPEEDUP_STAGES.size
    end
  end
end

module Graphics
  class << self
    alias fast_forward_update update
  end

  def self.update
    $frame += 1
    return if $frame % SPEEDUP_STAGES[$GameSpeed] != 0 && $CanToggle
    fast_forward_update
    $frame = 0
  end
end