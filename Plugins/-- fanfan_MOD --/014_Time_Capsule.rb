module TimeCapsule
  #TIME_CAPSULE_PATH = "Data"
  TIME_CAPSULE_FILE = "Time Capsule.dat"
  #PATH = "#{TIME_CAPSULE_PATH}/#{TIME_CAPSULE_FILE}"
  PATH = "#{TIME_CAPSULE_FILE}"
  @@time_capsule = []

  def self.read_time_capsule
    return [] unless File.exist?(PATH)
    encrypted_data = File.read(PATH)
    @@time_capsule = Marshal.restore(Zlib::Inflate.inflate(encrypted_data.unpack("m")[0]))
  end

  def self.open_time_capsule
    if $Trainer.party.empty?
      pbMessage(_INTL("You can't open the Time Capsule now!"))
      return
    end
    loop do
      if @@time_capsule.empty?
        pbMessage(_INTL("There aren't any Pokémon in the Time Capsule!"))
        return
      else
        data = pbChoosePkmnFromListEX(_INTL("Which Pokémon would you like to retrieve?"), @@time_capsule)
        pkmn = data[0]
        return unless pkmn
        if has_species?(pkmn.species, pkmn.form)
          pbMessage(_INTL("You can't retrieve this Pokémon! You already have one!"))
        else
          target_level = getLevelCap - 5
          if pkmn.level > target_level
            pkmn.level = target_level
            pkmn.calc_stats
          end
          pkmn.ownedByPlayer? ? pbAddPokemonSilent(pkmn, count: false) : pbAddPokemonSilent(pkmn)
          @@time_capsule.delete_at(data[1])
          pbMessage(_INTL("You retrieved {1}!", pkmn.name))
        end
      end
    end
  end

  def self.add_to_time_capsule(pkmn, ignore_confirm = false)
    if ignore_confirm || pbConfirmMessage(_INTL("Do you want to put {1} in the Time Capsule?", pkmn.name))
      @@time_capsule << pkmn
      pbMessage(_INTL("{1} is in the Time Capsule now!", pkmn.name))
      return true
    end
    return false
  end

  def self.update_time_capsule
    encrypted_data = [Zlib::Deflate.deflate(Marshal.dump(@@time_capsule))].pack("m")
    File.open(PATH, "wb") { |file| file.write(encrypted_data) }
  end
end

TimeCapsule.read_time_capsule