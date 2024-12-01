module CDKey
  @@pkmn_cd_key = {}
  @@item_cd_key = {}
  @@other_key   = {}

  def self.register_pkmn_key(key, pkmn, level = 1)
    @@pkmn_cd_key[key.downcase] = proc { pbAddPokemon(pkmn, level) }
  end

  def self.register_item_key(key, item, quantity = 1)
    @@item_cd_key[key.downcase] = proc { pbReceiveItem(item, quantity) }
  end

  def self.register_other_key(key)
    @@other_key[key.downcase] = proc { $Trainer.set_ta(key, true) }
  end

  def self.enter_cd_key
    text = pbEnterText("Enter a gift code.", 0, 30).downcase
    return if text.empty?
    valid_code = false
    if @@pkmn_cd_key.key?(text)
      valid_code = true
      if $Trainer.gift_code[:pkmn].include?(text)
        pbMessage(_INTL("The code has been used!"))
      else
        @@pkmn_cd_key[text]&.call
        $Trainer.gift_code[:pkmn] << text
      end
    end
    if @@item_cd_key.key?(text)
      valid_code = true
      if $Trainer.gift_code[:item].include?(text)
        pbMessage(_INTL("The code has been used!"))
      else
        @@item_cd_key[text]&.call
        $Trainer.gift_code[:item] << text
      end
    end
    if @@other_key.key?(text)
      valid_code = true
      @@other_key[text]&.call
    end
    pbMessage(_INTL("Please enter a valid gift code!")) if !valid_code
  end
end

CDKey.register_pkmn_key("hyena1", :PIKACHU)
CDKey.register_pkmn_key("psyduck10", :PORYGON, 10)
CDKey.register_item_key("pokeball5", :POKEBALL, 5)
CDKey.register_other_key("adaptiveai")
CDKey.register_other_key("rocket")