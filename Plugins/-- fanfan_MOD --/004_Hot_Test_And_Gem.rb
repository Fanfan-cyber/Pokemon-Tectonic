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
end