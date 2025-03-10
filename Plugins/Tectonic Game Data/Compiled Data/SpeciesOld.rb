module GameData
  class SpeciesOld < Species
    DATA = {}
    DATA_FILENAME = "species_old.dat"

    def legalityChecks; end;

    $loaded = false
    def self.loaded?
      return $loaded
    end

    def self.load
      super
      $loaded = true
    end
  end
end