MOVE_DATA = {
  :SWORDSDANCE => { :desc          => proc { _INTL("A frenetic dance to uplift the fighting spirit. It raises the user's Attack stat by three steps.") },
                    :function_code => "RaiseUserAtk3", },
  :YOUNGAGAIN => { :total_pp => 1, },
  :BEDTIME => { :function_code => "SleepTargetIfInFullMoonglow", },
}.freeze