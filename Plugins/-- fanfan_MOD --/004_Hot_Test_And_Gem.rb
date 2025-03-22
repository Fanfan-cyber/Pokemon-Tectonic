module LoadGem
  def self.load_gem
    require './Data/gems/chinese_pinyin-1.1.0/lib/chinese_pinyin'
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
  FILENAME = './Test_Content.rb'
  def self.load_refresh
    begin
      Dir["./Test/**/*.rb"].each { |file| load File.expand_path(file) }
      load FILENAME
      pbMessage(_INTL("Reloaded successfully!"))
    rescue LoadError
      begin
        File.open(FILENAME, 'wb') do |file|
          file.write("# This is a newly created file.\r\n")
        end
        load FILENAME
        pbMessage(_INTL("File was not found, but it has been created and loaded."))
      rescue => e
        pbMessage(_INTL("Failed to create or load the file.\n({1})", e.message))
      ensure
      end
    rescue => e
      pbMessage(_INTL("Failed to reload: An error occurred.\n({1})", e.message))
    ensure
    end
  end
end