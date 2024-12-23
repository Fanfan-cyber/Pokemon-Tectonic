#=============================================================================
# Dynamic Entry Screen
# Basic Edition
# ~Swdfm 2024-12-22
#==============================================================================
# Creates a "search bar"
# ie. Has a list that updates every time you type something
# Similar to a Search function
#=============================================================================
# Flags:
# :alphabetical. Orders search options in alphabetical order
# :include. Looks for strings that include the substring rather than start with it
# :sensitive. Anything typed is case sensitive
# :restrict. Stops user entering anything that isn't in the list
#-------------------------------
# Section 1: Dynamic Entry Screen: Keyboard
#-------------------------------
class PokemonEntryScene
  def pbStartScene_Dynamic(helptext, minlength, maxlength, initialText, subject = 0, pokemon = nil, full_commands = [], flags = [])
    @full_commands = full_commands
    @flags = flags
    if @flags.include?(:alphabetical)
      @full_commands.clone.sort!
    end
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    if USEKEYBOARD
      @sprites["entry"] = Window_TextEntry_Keyboard.new(
        initialText, 0, 0, 400 - 112, 96, helptext, true
      )
      Input.text_input = true
    else
      # @sprites["entry"] = Window_TextEntry.new(initialText, 0, 0, 400, 96, helptext, true)
    end
    @sprites["entry"].x = (Graphics.width / 2) - (@sprites["entry"].width / 2) + 32
    @sprites["entry"].viewport = @viewport
    @sprites["entry"].visible = true
    @minlength = minlength
    @maxlength = maxlength
    @symtype = 0
    @sprites["entry"].maxlength = maxlength
    if !USEKEYBOARD
      @sprites["entry2"] = Window_CharacterEntry.new(@@Characters[@symtype][0])
      @sprites["entry2"].setOtherCharset(@@Characters[@symtype][1])
      @sprites["entry2"].viewport = @viewport
      @sprites["entry2"].visible = true
      @sprites["entry2"].x = (Graphics.width / 2) - (@sprites["entry_list"].width / 2)
    end
    if minlength == 0
      @sprites["helpwindow"] = Window_UnformattedTextPokemon.newWithSize(
        _INTL("Enter text using the keyboard. Press\nEnter to confirm, or Esc to cancel."),
        32, Graphics.height - 96, Graphics.width - 64, 96, @viewport
      )
    else
      @sprites["helpwindow"] = Window_UnformattedTextPokemon.newWithSize(
        _INTL("Enter text using the keyboard.\nPress Enter to confirm."),
        32, Graphics.height - 96, Graphics.width - 64, 96, @viewport
      )
    end
    @sprites["helpwindow"].letterbyletter = false
    @sprites["helpwindow"].viewport = @viewport
    @sprites["helpwindow"].visible = USEKEYBOARD
    @sprites["helpwindow"].baseColor = Color.new(16, 24, 32)
    @sprites["helpwindow"].shadowColor = Color.new(168, 184, 184)
    if USEKEYBOARD
      @sprites["entry_list"] = Window_CommandPokemonEx.new([])
      @sprites["entry_list"].x = 0
      @sprites["entry_list"].y = @sprites["entry"].height
      @sprites["entry_list"].width = Graphics.width
      @sprites["entry_list"].height = Graphics.height - @sprites["helpwindow"].height - @sprites["entry"].height
      @sprites["entry_list"].viewport = @viewport
      @sprites["entry_list"].visible = true
      @prev_text = nil
    end
    addBackgroundPlane(@sprites, "background", "Naming/bg_2", @viewport)
    case subject
    when 1   # Player
      meta = GameData::PlayerMetadata.get($player.character_ID)
      if meta
        @sprites["shadow"] = IconSprite.new(0, 0, @viewport)
        @sprites["shadow"].setBitmap("Graphics/UI/Naming/icon_shadow")
        @sprites["shadow"].x = 66
        @sprites["shadow"].y = 64
        filename = pbGetPlayerCharset(meta.walk_charset, nil, true)
        @sprites["subject"] = TrainerWalkingCharSprite.new(filename, @viewport)
        charwidth = @sprites["subject"].bitmap.width
        charheight = @sprites["subject"].bitmap.height
        @sprites["subject"].x = 88 - (charwidth / 8)
        @sprites["subject"].y = 76 - (charheight / 4)
      end
    when 2   # Pokémon
      if pokemon
        @sprites["shadow"] = IconSprite.new(0, 0, @viewport)
        @sprites["shadow"].setBitmap("Graphics/UI/Naming/icon_shadow")
        @sprites["shadow"].x = 66
        @sprites["shadow"].y = 64
        @sprites["subject"] = PokemonIconSprite.new(pokemon, @viewport)
        @sprites["subject"].setOffset(PictureOrigin::CENTER)
        @sprites["subject"].x = 88
        @sprites["subject"].y = 54
        @sprites["gender"] = BitmapSprite.new(32, 32, @viewport)
        @sprites["gender"].x = 430
        @sprites["gender"].y = 54
        @sprites["gender"].bitmap.clear
        pbSetSystemFont(@sprites["gender"].bitmap)
        textpos = []
        if pokemon.male?
          textpos.push([_INTL("♂"), 0, 6, :left, Color.new(0, 128, 248), Color.new(168, 184, 184)])
        elsif pokemon.female?
          textpos.push([_INTL("♀"), 0, 6, :left, Color.new(248, 24, 24), Color.new(168, 184, 184)])
        end
        pbDrawTextPositions(@sprites["gender"].bitmap, textpos)
      end
    when 3   # NPC
      @sprites["shadow"] = IconSprite.new(0, 0, @viewport)
      @sprites["shadow"].setBitmap("Graphics/UI/Naming/icon_shadow")
      @sprites["shadow"].x = 66
      @sprites["shadow"].y = 64
      @sprites["subject"] = TrainerWalkingCharSprite.new(pokemon.to_s, @viewport)
      charwidth = @sprites["subject"].bitmap.width
      charheight = @sprites["subject"].bitmap.height
      @sprites["subject"].x = 88 - (charwidth / 8)
      @sprites["subject"].y = 76 - (charheight / 4)
    when 4   # Storage box
      @sprites["subject"] = TrainerWalkingCharSprite.new(nil, @viewport)
      @sprites["subject"].altcharset = "Graphics/UI/Naming/icon_storage"
      @sprites["subject"].anim_duration = 0.4
      charwidth = @sprites["subject"].bitmap.width
      charheight = @sprites["subject"].bitmap.height
      @sprites["subject"].x = 88 - (charwidth / 8)
      @sprites["subject"].y = 52 - (charheight / 2)
    end
    update_text_box
    pbFadeInAndShow(@sprites)
  end
  
#-------------------------------
  def pbEntry_Dynamic
    return USEKEYBOARD ? pbEntry1_Dynamic : pbEntry2
  end
  
#-------------------------------
  def pbEntry1_Dynamic
    ret = ""
    loop do
      Graphics.update
      Input.update
      if Input.triggerex?(:ESCAPE) && @minlength == 0
        ret = ""
        break
      elsif Input.triggerex?(:RETURN) && @sprites["entry"].text.length >= @minlength
        ret = @sprites["entry"].text
        break
      end
      @sprites["helpwindow"].update
      @sprites["entry"].update
      update_text_box
      @sprites["entry_list"].update
      @sprites["subject"]&.update
    end
    Input.update
    ret = @sprites["entry_list"].commands[@sprites["entry_list"].index]
    return ret
  end
  
#-------------------------------
  def update_text_box
    return unless !@prev_text || (@prev_text != @sprites["entry"].text)
    review_restrict
    n_cmds = []
    for cmd in @full_commands
      next unless check_text_box(@sprites["entry"].text, cmd)
      n_cmds.push(cmd.to_s)
    end
    if n_cmds.empty? && !@prev_text.nil? && @flags.include?(:restrict)
      @sprites["entry"].text = @prev_text
      return
    end
    @sprites["entry_list"].commands = n_cmds
    if @sprites["entry_list"].index >= @sprites["entry_list"].commands.length
      @sprites["entry_list"].index = 0
    end
    @prev_text = @sprites["entry"].text.clone
  end
  
#-------------------------------
  def check_text_box(check_text, check_against)
    if @flags.include?(:sensitive)
      if @flags.include?(:include)
        return check_against.to_s.include?(check_text)
      end
      return check_against.to_s[0, check_text.length] == check_text
    end
    if @flags.include?(:include)
      return check_against.to_s.downcase.include?(check_text.downcase)
    end
    return check_against.to_s.downcase[0, check_text.length] == check_text.downcase
  end
  
#-------------------------------
  def review_restrict
    return unless @flags.include?(:restrict)
    for cmd in @full_commands
      return if check_text_box(@sprites["entry"].text, cmd)
    end
    pbPlayBuzzerSE
    @sprites["entry"].delete
    @sprites["entry"].update
  end
end

#-------------------------------
class PokemonEntry
  def pbStartScreen_Dynamic(helptext, minlength, maxlength, initialText, mode = -1, pokemon = nil, full_commands = [], flags = [])
    @scene.pbStartScene_Dynamic(helptext, minlength, maxlength, initialText, mode, pokemon, full_commands, flags)
    ret = @scene.pbEntry_Dynamic
    @scene.pbEndScene
    return ret
  end
end

#-------------------------------
def pbEnterSearchText(array, flags = [:restrict], helptext = "Enter Text")
  pbFadeOutIn(99999, false) do
    sscene = PokemonEntryScene.new
    sscreen = PokemonEntry.new(sscene)
    mode = 0
    pokemon = nil
    minlength = 0
    maxlength = array.sort{ |a, b|
      a.length <=> b.length
    }
    maxlength = maxlength[-1].length # Length of largest!
    ret = sscreen.pbStartScreen_Dynamic(helptext, minlength, maxlength, "", mode, pokemon, array.clone, flags)
    ret = array.index(ret)
    return ret
  end
end

#=============================================================================
# Examples:
#-------------------------------
# To do one for all species: (Useful for Pokédex)
# Put:
def pbGetAllSpeciesNames
  ret = []
  GameData::Species.each_species do |data|
    ret.push(data.name)
  end
  return ret
end

# Then use:
# pbEnterSearchText(pbGetAllSpeciesNames)
# To do so in alphabetical order, use:
# pbEnterSearchText(pbGetAllSpeciesNames, [:alphabetical, :restrict])

#-------------------------------
# To do one for all maps: (Useful for Debug)
#-------------------------------
# Alternative Warp To Map
# To do this in Debug as standard, remove the _Swdfm from def line,
#  then remove any comments in this method under this one!
alias warp_to_map_swdfm pbWarpToMap
def pbWarpToMap_Swdfm
  $ignore_debug_list = true
  map = warp_to_map_swdfm
  $ignore_debug_list = false
  # return map
  return false if !map
  if $scene.is_a?(Scene_Map)
    $game_temp.player_new_map_id    = map[0]
    $game_temp.player_new_x         = map[1]
    $game_temp.player_new_y         = map[2]
    $game_temp.player_new_direction = 2
    $scene.transfer_player
  else
    pbCancelVehicles
    $map_factory.setup(map[0])
    $game_player.moveto(map[1], map[2])
    $game_player.turn_down
    $game_map.update
    $game_map.autoplay
  end
  $game_map.refresh
end

#-------------------------------
# Used for above method!
alias list_screen_swdfm pbListScreen
def pbListScreen(title = nil, lister = nil)
  return list_screen_swdfm(title, lister) if !$ignore_debug_list
  commands = []
  mapfiles = {}
  # Get IDs of all maps in the Data folder
  Dir.chdir("Data") do
    mapData = sprintf("Map*.rxdata")
    Dir.glob(mapData).each do |map|
      mapfiles[$1.to_i(10)] = true if map[/map(\d+)\.rxdata/i]
    end
  end
  mapinfos = pbLoadMapInfos
  maxOrder = 0
  ids = []
  # Exclude maps found in mapinfos
  mapinfos.each_key do |id|
    commands.push("#{mapinfos[id].name} (ID #{id})")
    ids.push(id)
  end
  ret = pbEnterSearchText(commands, [:alphabetical, :restrict]) || 0
  return ids[ret]
end