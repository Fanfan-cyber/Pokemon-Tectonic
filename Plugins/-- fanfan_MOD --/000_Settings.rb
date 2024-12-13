module Settings
  NUM_STORAGE_BOXES = 200

  # Button used for Text Skipping (Default = :X)
  TEXT_SKIP_KEY = :V

  # Button used for Fast Forward (Default = :F)
  FAST_FORWARD_KEY = :Q

  FAINT_HEALING_TURN = 10
  SWITCH_HEALING_NUM = 10
  BATTLE_ENDING_NUBM = 30
end

def load_refresh
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
    rescue StandardError => e
      pbMessage(_INTL("Failed to create or load the file."))
    ensure
    end
  rescue StandardError => e
    pbMessage(_INTL("Failed to reload: An error occurred."))
  ensure
  end
end