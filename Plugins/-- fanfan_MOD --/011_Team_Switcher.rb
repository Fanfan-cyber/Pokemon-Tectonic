module TeamSwitcher
  def self.open_team_switcher
    return pbMessage(_INTL("Sorry, unfinished yet!"))
    teams = $Trainer.team_switcher
    if teams.empty?
      pbMessage(_INTL("You don't have any teamshots in Team Switcher!"))
    else
      names = teams.map { |team| team[0] } # [ [ name, [ team ] ], ]
      index = pbMessage(_INTL("Which team would you like to use?"), names)
      if index >= 0
        choice = [_INTL("Check Team"), _INTL("Switch Team"), _INTL("Delete Team"), _INTL("Cancel")]
        choose = pbMessage(_INTL("What do you want to do?"), choice, -1)
        case choose
        when 0
          
        when 1
          
        when 2
          
        end
      end
    end
  end
end
