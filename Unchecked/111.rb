module GameData
  class Abilities
    @@raw_data = nil
    @@data     = nil
    CACHE_PATH = "Data/abilities.dat"

    def self.raw_data
      @@raw_data ||= {
        :OVERGROW => {
          :id          => :OVERGROW,
          :name        => "Overgrow",
          :description => "HP≤1/3时草系招式威力+50%",
          :flags       => [:type_boost],
          :score       => 5
        },
        :TORRENT => {
          :id          => :TORRENT,
          :name        => "Torrent",
          :description => "HP≤1/3时水系招式威力+50%",
          :flags       => [:type_boost],
          :score       => 5
        },
      }
    end

    def self.build_data
      id_index = {}
      flags_index = Hash.new { |h, k| h[k] = [] }
      score_index = Hash.new { |h, k| h[k] = [] }

      raw_data.each_value do |data|
        ability = new(data)
        id_index[data[:id]] = ability
        data[:flags].each { |flag| flags_index[flag] << ability }
        score_index[data[:score]] << ability
      end
      @@raw_data = nil

      @@data = {
        :by_id    => id_index,
        :by_flag  => flags_index,
        :by_score => score_index,
      }.freeze
      save_cache
    end

    def self.save_cache
      File.open(CACHE_PATH, "wb") do |f|
        f.write(Marshal.dump({
          :version => MOD_VERSION,
          :data    => @@data
        }))
      end
    end

    def self.load_cache
      if $DEBUG || !FileTest.exist?(CACHE_PATH)
        build_data
      else
        need_build = false
        begin
          File.open(CACHE_PATH, "rb") do |f|
            cache = Marshal.load(f.read)
            if cache[:version] == MOD_VERSION
              @@data = cache[:data]
            else
              need_build = true
            end
          end
        rescue
          need_build = true
        end
        build_data if need_build
      end
    end

    def self.get(id)
      @@data[:by_id][id]
    end

    def self.get_by_name(name)
      all.find { |ability| ability.name == name }
    end

    def self.all
      @@data[:by_id].values
    end

    def self.with_flag(flag)
      @@data[:by_flag][flag] || []
    end

    def self.with_score(score)
      @@data[:by_score][score] || []
    end

    def self.with_score_range(min, max)
      @@data[:by_score].flat_map do |score, abilities|
        (min <= score && score <= max) ? abilities : []
      end
    end

    attr_reader :id, :name, :description, :flags, :score

    def initialize(data)
      @id          = data[:id]
      @name        = data[:name]        || ""
      @description = data[:description] || ""
      @flags       = data[:flags]       || []
      @score       = data[:score]       || 5
    end
  end
end

GameData::Abilities.load_cache