module AdoptionCenter
  DEFAULT_AP      = 5
  AP_PER_BATTLE   = 5
  ADOPTION_CENTER = { 10 => %i[MVOLTORB], 
                      30 => %i[], 
                      50 => %i[], 
                    }.freeze

  def self.open_adoption_center
    loop do
      choice = [_INTL("Adopt"), _INTL("Check AP"), _INTL("Explain"), _INTL("Cancel")]
      choose = pbMessage(_INTL("What do you want to do?"), choice, -1)
      case choose
      when -1, 3 # Cancel
        break
      when 0 # Adopt
        adopt_pkmn
        break
      when 1 # Check AP
        ap = available_ap
        unless ap > 0
          pbMessage(_INTL("You don't have any AP."))
        else
          pbMessage(_INTL("Your available AP are {1}.", ap))
        end
      when 2 # Explain
        pbMessage(_INTL("Adoption Center is a place where you can adopt Pokémon with your Adoption Point(AP)!\nYou can get AP when you win a battle."))
      end
    end
  end

  def self.adopt_pkmn
    loop do
      choice = [_INTL("10 AP Zone"), _INTL("30 AP Zone"),  _INTL("50 AP Zone"), _INTL("Cancel")]
      choose = pbMessage(_INTL("Which Zone?"), choice, -1)
      case choose
      when -1, 3
        break
      when 0
        break if choose_pkmn(10)
      when 1
        break if choose_pkmn(30)
      when 2
        break if choose_pkmn(50)
      end
    end
  end

  def self.choose_pkmn(zone)
    pkmns = available_pkmn(zone)
    if pkmns.empty?
      pbMessage(_INTL("There aren't any Pokémon you can adopt from this Zone!"))
      return
    else
      data = pbChoosePkmnFromListEX(_INTL("Which Pokémon would you like to adopt?"), pkmns)
      pkmn = data[0]
      pkmn_index = data[1]
      return unless pkmn
      if pbConfirmMessage(_INTL("Do you want to adopt this Pokémon?"))
        if has_species?(pkmn)
          pbMessage(_INTL("You can't adopt this Pokémon! You already have one!"))
          return
        elsif available_ap < zone
          pbMessage(_INTL("You can't adopt this Pokémon! You don't have enough AP!"))
        else
          TA.increase(:ap_used, zone)
          TA.set(:adopted, []) unless TA.get(:adopted)
          TA.get(:adopted) << pkmn
          pbAddPokemon(pkmn, getLevelCap - 5)
          return true
        end
      end
    end
  end

  def self.available_ap
    DEFAULT_AP + TA.get(:win, 0) * AP_PER_BATTLE - TA.get(:ap_used, 0)
  end

  def self.available_pkmn(zone)
    ADOPTION_CENTER[zone] - TA.get(:adopted, [])
  end
end