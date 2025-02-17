module CDKey
  @@pkmn_cd_key = {}
  @@item_cd_key = {}
  @@other_key   = {}

  def self.register_pkmn_key(key, pkmn, level = 1)
    @@pkmn_cd_key[key.to_sym] = proc { pbAddPokemon(pkmn, level) }
  end

  def self.register_item_key(key, item, quantity = 1)
    @@item_cd_key[key.to_sym] = proc { pbReceiveItem(item, quantity) }
  end

  def self.register_other_key(key, value = true)
    key = [key.to_sym] if !key.is_a?(Array)
    @@other_key[key[0]] = proc { TA.set(key[-1], value) }
  end

  def self.enter_cd_key
    text = pbEnterText(_INTL("Enter a code."), 0, 30).to_sym
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
    pbMessage(_INTL("Please enter a valid code!")) if !valid_code
  end

  UNUSED_CODE = %i[whosyourdaddy adaptiveai nocopymon]

  def self.clear_unused_code
    UNUSED_CODE.each { |code| TA.set(code, false) }
  end
end

CDKey.register_other_key(:infinitehp)
CDKey.register_other_key([:noinfinitehp, :infinitehp], false)
CDKey.register_other_key(:immunestatus)
CDKey.register_other_key([:noimmunestatus, :immunestatus], false)
CDKey.register_other_key(:hugepower)
CDKey.register_other_key([:nohugepower, :hugepower], false)
CDKey.register_other_key(:guaranteedeffects)
CDKey.register_other_key([:noguaranteedeffects, :guaranteedeffects], false)
CDKey.register_other_key(:guaranteedcrit)
CDKey.register_other_key([:noguaranteedcrit, :guaranteedcrit], false)

CDKey.register_other_key(:maxmoney)
CDKey.register_other_key(:alltribes)
CDKey.register_other_key([:disablealltribes, :alltribes], false)
CDKey.register_other_key(:notribecopy)
CDKey.register_other_key([:disablenotribecopy, :notribecopy], false)

CDKey.register_other_key(:rocket)
CDKey.register_other_key([:norocket, :rocket], false)
CDKey.register_other_key(:customabil)
CDKey.register_other_key([:nocustomabil, :customabil], false)
#CDKey.register_other_key(:whosyourdaddy)
#CDKey.register_other_key([:nodaddy, :whosyourdaddy], false)
#CDKey.register_other_key(:adaptiveai)
#CDKey.register_other_key(:nocopymon)
#CDKey.register_other_key([:copymonagain, :nocopymon], false)

CDKey.register_pkmn_key(:hyena1, :PIKACHU)
CDKey.register_pkmn_key(:psyduck10, :PORYGON, 10)

CDKey.register_item_key(:pokeball5, :POKEBALL, 5)