module TimeCapsule
  TIME_CAPSULE_PATH = "Data"
  TIME_CAPSULE_FILE = "time_capsule.dat"
  PATH = "#{TIME_CAPSULE_PATH}/#{TIME_CAPSULE_FILE}"
  @@time_capsule = []

  def self.read_time_capsule
    return [] if !File.exist?(PATH)
    encrypted_data = File.read(PATH)
    @@time_capsule = Marshal.restore(Zlib::Inflate.inflate(encrypted_data.unpack("m")[0]))
  end

  def self.open_time_capsule
    if @@time_capsule.empty?
      pbMessage(_INTL("There isn't any Pokémon in Time Capsule!"))
    else
      data = pbChoosePkmnFromListEX(_INTL("Which Pokémon would you like to retrieve?"), @@time_capsule)
      return if !data[0]
      if has_species?(data[0].species, data[0].form)
        pbMessage(_INTL("You can't retrieve this Pokémon! You already have one!"))
      else
        pbAddPokemon(data[0])
        @@time_capsule.delete_at(data[1])
      end
    end
  end

  def self.add_to_time_capsule(pkmn)
    if pbConfirmMessage(_INTL("Do you want to put {1} in Time Capsule?", pkmn.name))
      @@time_capsule << pkmn
      pbMessage(_INTL("{1} is now in Time Capsule!", pkmn.name))
    end
  end

  def self.update_time_capsule
    encrypted_data = [Zlib::Deflate.deflate(Marshal.dump(@@time_capsule))].pack("m")
    File.open(PATH, "wb") do |file|
      file.write(encrypted_data)
    end
  end
end

TimeCapsule.read_time_capsule