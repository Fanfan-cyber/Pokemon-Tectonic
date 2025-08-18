# mkxp-z extra libraries
# macOS version of mkxp-z has the standard libraries located elsewhere but they're in load path by default.
$:.push File.join(Dir.pwd, "Library/stdlib") unless System.platform[/macOS/]
# Fix loading of rbconfig gem.
$:.push File.join(Dir.pwd, "Library/stdlib/x64-mingw32") if System.platform[/Windows/]
$:.push File.join(Dir.pwd, "Library/stdlib/x86_64-linux") if System.platform[/Linux/]
$:.push File.join(Dir.pwd, "../Resources/Ruby/3.1.0/x86_64-darwin") if System.platform[/macOS/]
# Add external gems to load path.
#$:.push File.join(Dir.pwd, "Library/gems")

# JoiPlay RPG Maker Plugin 1.20.51 completely broke require so we have to use require_relative instead.
def gem(name)
  if $joiplay
    require File.expand_path("../Library/gems/" + name + ".rb", __FILE__)
  else
    require name
  end
end

module LoadGem
  def self.load_gem
    require "./Library/gems/chinese_pinyin-1.1.0/lib/chinese_pinyin"
  end
end

LoadGem.load_gem

module Input
  class << self
    alias hot_test_update update
  end

  def self.update
    hot_test_update
    if MInput.hot_reloaded? && $DEBUG #triggerex?(:H)
      AbilitySystem.clear_cache
      HotTest.load_refresh
      #pbMapInterpreter.execute_script("HotTest.load_refresh")
    end
  end
end

module HotTest
  def self.load_refresh
    begin
      Dir["./Test/**/*.rb"].each { |file| load File.expand_path(file) }
      load "./Test_Script.rb"
      pbMessage(_INTL("Reloaded successfully!"))
    rescue => e
      pbMessage(_INTL("Failed to reload: An error occurred.\n({1})", e.message))
    ensure
    end
  end

  def self.load_custom_type_chart
    custom_path = "./Custom_Type_Chart.rb"
    begin
      unless File.exist?(custom_path)
        TA.set(:customtypechart, nil)
        File.open(custom_path, "wb") do |file|
          file.write(<<~DEFAULT_CHART)
            CUSTOM_TYPE_CHART = {
              :BUG      => { :Weaknesses => %i[FIRE FLYING ROCK],                  :Resistances => %i[FIGHTING GRASS GROUND PSYCHIC],                        :Immunities => %i[], },
              :DARK     => { :Weaknesses => %i[BUG FAIRY FIGHTING],                :Resistances => %i[DARK GHOST],                                           :Immunities => %i[PSYCHIC], },
              :DRAGON   => { :Weaknesses => %i[DRAGON FAIRY ICE],                  :Resistances => %i[ELECTRIC FIRE GRASS WATER],                            :Immunities => %i[], },
              :ELECTRIC => { :Weaknesses => %i[GROUND],                            :Resistances => %i[ELECTRIC FLYING STEEL],                                :Immunities => %i[], },
              :FAIRY    => { :Weaknesses => %i[BUG POISON STEEL],                  :Resistances => %i[DARK DRAGON FIGHTING],                                 :Immunities => %i[], },
              :FIGHTING => { :Weaknesses => %i[FAIRY FLYING PSYCHIC],              :Resistances => %i[BUG DARK ROCK],                                        :Immunities => %i[], },
              :FIRE     => { :Weaknesses => %i[GROUND ROCK WATER],                 :Resistances => %i[BUG FIRE GRASS ICE STEEL],                             :Immunities => %i[], },
              :FLYING   => { :Weaknesses => %i[ELECTRIC ICE ROCK],                 :Resistances => %i[BUG FIGHTING GRASS],                                   :Immunities => %i[GROUND], },
              :GHOST    => { :Weaknesses => %i[DARK GHOST],                        :Resistances => %i[BUG POISON],                                           :Immunities => %i[FIGHTING NORMAL], },
              :GRASS    => { :Weaknesses => %i[BUG FIRE FLYING ICE POISON],        :Resistances => %i[ELECTRIC FAIRY GHOST GRASS GROUND WATER],              :Immunities => %i[], },
              :GROUND   => { :Weaknesses => %i[ICE GRASS WATER ],                  :Resistances => %i[POISON ROCK],                                          :Immunities => %i[ELECTRIC], },
              :ICE      => { :Weaknesses => %i[FIGHTING FIRE ROCK STEEL],          :Resistances => %i[FLYING GROUND ICE],                                    :Immunities => %i[], },
              :MUTANT   => { :Weaknesses => %i[DRAGON NORMAL],                     :Resistances => %i[ELECTRIC DARK FIGHTING GHOST POISON ROCK],             :Immunities => %i[FIRE ICE], },
              :NORMAL   => { :Weaknesses => %i[FIGHTING],                          :Resistances => %i[],                                                     :Immunities => %i[GHOST], },
              :POISON   => { :Weaknesses => %i[GROUND PSYCHIC],                    :Resistances => %i[BUG FAIRY FIGHTING GRASS POISON],                      :Immunities => %i[], },
              :PSYCHIC  => { :Weaknesses => %i[BUG DARK GHOST],                    :Resistances => %i[FIGHTING PSYCHIC STEEL],                               :Immunities => %i[], },
              :ROCK     => { :Weaknesses => %i[FIGHTING GRASS GROUND STEEL WATER], :Resistances => %i[FIRE FLYING ICE NORMAL POISON],                        :Immunities => %i[], },
              :STEEL    => { :Weaknesses => %i[FIGHTING FIRE GROUND PSYCHIC],      :Resistances => %i[BUG DRAGON FAIRY FLYING GRASS ICE NORMAL ROCK STEEL],  :Immunities => %i[POISON], },
              :WATER    => { :Weaknesses => %i[ELECTRIC GRASS POISON],             :Resistances => %i[FIRE ICE STEEL WATER],                                 :Immunities => %i[], },
            }.freeze
          DEFAULT_CHART
        end
        pbMessage(_INTL("Created default Type Chart. You can modify the file and input the code again to apply."))
      else
        content = File.read(custom_path).chomp
        raise unless content.lines.count == 21
        raise unless content.start_with?("CUSTOM_TYPE_CHART = {")
        raise unless content.end_with?("}.freeze")
        load custom_path
        TA.set(:customtypechart, CUSTOM_TYPE_CHART)
        pbMessage(_INTL("New Coustom Type Chart reloaded successfully!"))
      end
    rescue => e
      pbMessage(_INTL("Failed to reload: An error occurred.\n({1})", e.message))
    ensure
    end
  end
end

