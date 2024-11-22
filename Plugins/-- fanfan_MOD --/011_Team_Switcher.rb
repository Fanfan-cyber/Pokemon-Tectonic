module TeamSwitcher
  def self.open_team_switcher
    team_shots = $Trainer.team_switcher
    loop do
      choice = [_INTL("Check Team"), _INTL("Shot Team"), _INTL("Switch Team"), _INTL("Delete Team"), _INTL("Cancel")]
      choose = pbMessage(_INTL("What do you want to do?"), choice, -1)
      case choose
      when -1, 4
        break
      when 0 # Check Team
        if team_shots.empty?
          pbMessage(_INTL("You don't have any teamshots in Team Switcher!"))
        else
          names = team_shots.map { |team| team[0] } # [ [ name, [ team ] ], ]
          index = pbMessage(_INTL("Which team would you like to check?"), names, -1)
          if index >= 0
            # to-do
            return pbMessage(_INTL("Sorry, unfinished yet!"))
          end
        end
      when 1 # Shot Team
        pbMessage(_INTL("Please give it a name!"))
        name = pbEnterText(_INTL("What name?"), 0, 30)
        name = _INTL("Unnamed") if name.empty?
        party_member_ids = $Trainer.party.map(&:unique_id)
        team_shots << [name, party_member_ids]
        pbMessage(_INTL("Your team has been shot!"))
      when 2 # Switch Team
        if team_shots.empty?
          pbMessage(_INTL("You don't have any teamshots in Team Switcher!"))
        else
          names = team_shots.map { |team| team[0] } # [ [ name, [ team ] ], ]
          index = pbMessage(_INTL("Which team do you want to use?"), names, -1)
          if index >= 0 && pbConfirmMessage(_INTL("Do you really want to use it?"))
            # to-do
            return pbMessage(_INTL("Sorry, unfinished yet!"))
          end
        end
      when 3 # Delete Team
        if team_shots.empty?
          pbMessage(_INTL("You don't have any teamshots in Team Switcher!"))
        else
          names = team_shots.map { |team| team[0] } # [ [ name, [ team ] ], ]
          index = pbMessage(_INTL("Which team do you want to delete?"), names, -1)
          if index >= 0 && pbConfirmMessage(_INTL("Do you really want to delete it?"))
            team_shots.delete_at(index)
            pbMessage(_INTL("This team has been deleted!"))
          end
        end
      end
    end
  end
end
