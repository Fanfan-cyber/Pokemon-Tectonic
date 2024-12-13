module Input
  class << Input
    alias hot_test_update update
  end

  def self.update
    hot_test_update
    if triggerex?(:H) && $DEBUG
      HotTest.load_refresh
    elsif triggerex?(:L) && $DEBUG
      pbMapInterpreter.execute_script("HotTest.load_refresh")
    end
  end
end

module HotTest
  def self.load_refresh
    filename = './Plugins/-- fanfan_MOD --/998_Hot_Test.rb'
    begin
      load filename
      pbMessage(_INTL("Reloaded successfully!"))
    rescue LoadError
      begin
        File.open(filename, 'wb') do |file|
          file.write("# This is a newly created file.\r\n")
        end
        load filename
        pbMessage(_INTL("File was not found, but it has been created and loaded."))
      rescue StandardError
        pbMessage(_INTL("Failed to create or load the file."))
      ensure
      end
    rescue StandardError
      pbMessage(_INTL("Failed to reload: An error occurred."))
    ensure
    end
  end
end