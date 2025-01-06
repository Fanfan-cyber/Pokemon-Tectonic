class PBZ_IM_quanpin < Array
  attr_reader :value

  def initialize
    init
  end

  def init
    @value = ""
    clear
  end

  def add(char)
    if @value.size < 10
      @value += char.downcase
      clear
      text = PINYIN_DATA[@value]
      concat(text.split(//)) if text
      return true
    else
      return false
    end
  end

  def back 
    if @value != ""
      value = @value.split(//)
      @value = ""
      for i in 0..(value.size - 2)
        @value += value[i]
      end
      clear
      text = PINYIN_DATA[@value]
      concat(text.split(//)) if text
      return true
    else
      return false
    end
  end
end

#===============================================================================
# Text entry screen - arrows to select letter.
#===============================================================================
class PokemonEntryScene2
  @@Characters = [
    [("             " + "QWERTYUIOP[]\\" + "ASDFGHJKL;':\"" + "ZXCVBNM,./<>?" + "             ").scan(/./), _INTL("Pinyin")],
    [("ABCDEFGHIJKLM" + "NOPQRSTUVWXYZ" + "abcdefghijklm" + "nopqrstuvwxyz" + "0123456789   ").scan(/./), _INTL("Alphabet")],
    [(",.'\":;!?   ♂♀" + "~@#*&$§()    " + "【】[]{}<>《》   " + "+-×÷=±%      " + "^_/\\|        ").scan(/./), _INTL("Symbols")]
  ]

  MODE1 = -5
  MODE2 = -4
  MODE3 = -3

  MaxCharsPerLine = 11

  HELPER_TEXT_X_OFFSET = 0
  HELPER_TEXT_Y_OFFSET = 0

  TEXT_X_OFFSET = 0
  TEXT_Y_OFFSET = 0

  PINYIN_X_OFFSET = 0
  PINYIN_Y_OFFSET = 0

  ALPHABET_X_OFFSET = 0
  ALPHABET_Y_OFFSET = 0

  class NameEntryCursor
    NAMING_PATH = "Graphics/Pictures/Naming2"

    def initialize(viewport)
      @sprite = SpriteWrapper.new(viewport)
      @cursortype = 0
      @cursor1 = AnimatedBitmap.new("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/cursor_1")
      @cursor2 = AnimatedBitmap.new("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/cursor_2")
      @cursor3 = AnimatedBitmap.new("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/cursor_3")
      @cursorPos = 0
      updateInternal
    end

    # QAQ
    def z=(value)
      @sprite.z = value
    end

    def updateCursorPos
      value = @cursorPos
      case value
      when PokemonEntryScene2::MODE1   # Upper case
        @sprite.x = 48
        @sprite.y = 120
        @cursortype = 1
      when PokemonEntryScene2::MODE2   # Lower case
        @sprite.x = 112
        @sprite.y = 120
        @cursortype = 1
      when PokemonEntryScene2::MODE3   # Other symbols
        @sprite.x = 176
        @sprite.y = 120
        @cursortype = 1
      when PokemonEntryScene2::BACK   # Back
        @sprite.x = 319
        @sprite.y = 120
        @cursortype = 2
      when PokemonEntryScene2::OK   # OK
        @sprite.x = 399
        @sprite.y = 120
        @cursortype = 2
      else
        if value >= 0
          @sprite.x = 52 + 32 * (value % PokemonEntryScene2::ROWS)
          @sprite.y = 176 + 38 * (value / PokemonEntryScene2::ROWS)
          @cursortype = 0
        end
      end
    end
  end

  # QAQ
  def prevPage
    if @IM_page > 0
      @IM_page -= 1
      $game_system.se_play($data_system.decision_se)
    end
  end

  # QAQ
  def nextPage
    if @IM_page < @IM.size / MaxCharsPerLine
      @IM_page += 1
      $game_system.se_play($data_system.decision_se)
    end
  end

  def pbStartScene(helptext, minlength, maxlength, initialText, subject = 0, pokemon = nil)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @helptext = helptext
    @helper = CharacterEntryHelper.new(initialText)
    @IM = PBZ_IM_quanpin.new # QAQ
    @IM_page = 0 # QAQ
    # Create bitmaps
    @bitmaps = []
    for i in 0...@@Characters.length
      @bitmaps[i] = AnimatedBitmap.new(sprintf("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/overlay_tab_#{i + 1}"))
      b = @bitmaps[i].bitmap.clone
      pbSetSystemFont(b)
      textPos = []
      for y in 0...COLUMNS
        for x in 0...ROWS
          pos = y * ROWS + x
          textPos.push([@@Characters[i][0][pos], 44 + x * 32 + ALPHABET_X_OFFSET, 8 + y * 38 + ALPHABET_Y_OFFSET, 2,
            Color.new(248, 248, 248), Color.new(120, 120, 120)])
        end
      end
      pbDrawTextPositions(b, textPos)
      @bitmaps[@@Characters.length + i] = b
    end
    underline_bitmap = BitmapWrapper.new(24, 6)
    underline_bitmap.fill_rect(2, 2, 22, 4, Color.new(0, 102, 170))
    underline_bitmap.fill_rect(0, 0, 22, 4, Color.new(0, 187, 255))
    @bitmaps.push(underline_bitmap)
    # Create sprites
    @sprites = {}
    @sprites["bg"] = IconSprite.new(0, 0, @viewport)
    @sprites["bg"].setBitmap("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/bg")
    case subject
    when 1   # Player
      meta = GameData::Metadata.get_player($Trainer.character_ID)
      if meta
        @sprites["shadow"] = IconSprite.new(0, 0, @viewport)
        @sprites["shadow"].setBitmap("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/icon_shadow")
        @sprites["shadow"].x = 58
        @sprites["shadow"].y = 64
        filename = pbGetPlayerCharset(meta, 1, nil, true)
        @sprites["subject"] = TrainerWalkingCharSprite.new(filename, @viewport)
        charwidth = @sprites["subject"].bitmap.width
        charheight = @sprites["subject"].bitmap.height
        @sprites["subject"].x = 88 - charwidth / 8
        @sprites["subject"].y = 76 - charheight / 4
      end
    when 2   # Pokémon
      if pokemon
        @sprites["shadow"] = IconSprite.new(0, 0, @viewport)
        @sprites["shadow"].setBitmap("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/icon_shadow")
        @sprites["shadow"].x = 58
        @sprites["shadow"].y = 64
        @sprites["subject"] = PokemonIconSprite.new(pokemon, @viewport)
        @sprites["subject"].setOffset(PictureOrigin::Center)
        @sprites["subject"].x = 88
        @sprites["subject"].y = 54
        @sprites["gender"] = BitmapSprite.new(32, 32, @viewport)
        @sprites["gender"].x = 430
        @sprites["gender"].y = 54
        @sprites["gender"].bitmap.clear
        pbSetSystemFont(@sprites["gender"].bitmap)
        textpos = []
        if pokemon.male?
          textpos.push([_INTL("♂"), 0, 0, false, Color.new(0, 128, 248), Color.new(168, 184, 184)])
        elsif pokemon.female?
          textpos.push([_INTL("♀"), 0, 0, false, Color.new(248, 24, 24), Color.new(168, 184, 184)])
        end
        pbDrawTextPositions(@sprites["gender"].bitmap, textpos)
      end
    when 3   # NPC
      @sprites["shadow"] = IconSprite.new(0, 0, @viewport)
      @sprites["shadow"].setBitmap("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/icon_shadow")
      @sprites["shadow"].x = 58
      @sprites["shadow"].y = 64
      @sprites["subject"] = TrainerWalkingCharSprite.new(pokemon.to_s, @viewport)
      charwidth = @sprites["subject"].bitmap.width
      charheight = @sprites["subject"].bitmap.height
      @sprites["subject"].x = 88 - charwidth / 8
      @sprites["subject"].y = 76 - charheight / 4
    when 4   # Storage box
      @sprites["subject"] = TrainerWalkingCharSprite.new(nil, @viewport)
      @sprites["subject"].altcharset = "#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/icon_storage"
      @sprites["subject"].animspeed = 4
      charwidth = @sprites["subject"].bitmap.width
      charheight = @sprites["subject"].bitmap.height
      @sprites["subject"].x = 88 - charwidth / 8
      @sprites["subject"].y = 52 - charheight / 2
    end
    @sprites["bgoverlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["bgoverlay"].z = 100000 # QAQ
    pbDoUpdateOverlay
    @blanks = []
    @mode = 0
    @minlength = minlength
    @maxlength = maxlength
    @maxlength.times { |i|
      @sprites["blank#{i}"] = SpriteWrapper.new(@viewport)
      @sprites["blank#{i}"].x = 160 + 24 * i
      @sprites["blank#{i}"].bitmap = @bitmaps[@bitmaps.length - 1]
      @blanks[i] = 0
    }
    @sprites["bottomtab"] = SpriteWrapper.new(@viewport)   # Current tab
    @sprites["bottomtab"].x = 22
    @sprites["bottomtab"].y = 162
    @sprites["bottomtab"].bitmap = @bitmaps[@@Characters.length]
    @sprites["toptab"]=SpriteWrapper.new(@viewport)   # Next tab
    @sprites["toptab"].x = 22 - 504
    @sprites["toptab"].y = 162
    @sprites["toptab"].bitmap = @bitmaps[@@Characters.length + 1]
    @sprites["controls"] = IconSprite.new(0, 0, @viewport)
    @sprites["controls"].x = 16
    @sprites["controls"].y = 96
    @sprites["controls"].setBitmap(addLanguageSuffix(("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/overlay_controls")))
    @init = true
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbDoUpdateOverlay2
    @sprites["cursor"] = NameEntryCursor.new(@viewport)
    @sprites["cursor"].z = 100001 # QAQ
    @cursorpos = 0
    @refreshOverlay = true
    @sprites["cursor"].setCursorPos(@cursorpos)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbDoUpdateOverlay2
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    modeIcon = [[addLanguageSuffix(("#{PokemonEntryScene2::NameEntryCursor::NAMING_PATH}/icon_mode")), 48 + @mode * 64, 120, @mode * 60, 0, 60, 44]]
    pbDrawImagePositions(overlay, modeIcon)
  end

  # QAQ
  def pbDoUpdateOverlay
    return if !@refreshOverlay
    @refreshOverlay = false
    bgoverlay = @sprites["bgoverlay"].bitmap
    bgoverlay.clear
    pbSetSystemFont(bgoverlay)
    textPositions = [
       [@helptext, 160 + HELPER_TEXT_X_OFFSET, 0 + HELPER_TEXT_Y_OFFSET, false, Color.new(248, 248, 248), Color.new(120, 120, 120)]
    ]
    chars = @helper.textChars # QAQ + @IM.value.split(//)
    x = 166 - 8
    for ch in chars
      textPositions.push([ch, x + TEXT_X_OFFSET, 37 + TEXT_Y_OFFSET, false, Color.new(248, 248, 248), Color.new(120, 120, 120)])
      x += 24
    end
    pbDrawTextPositions(bgoverlay, textPositions)

    # QAQ
    @IM_chars = []
    if !@IM.value.empty?
      _IM = [@IM.value[-1]] + @IM
      if _IM.size > MaxCharsPerLine
        l_char = (@IM_page > 0) ? ["←"] : ["·"]
        r_char = (@IM_page < _IM.size / MaxCharsPerLine) ? ["→"] : ["·"]
        @IM_chars = l_char + _IM[@IM_page * MaxCharsPerLine, MaxCharsPerLine] + r_char
      else
        @IM_chars = ["·"] + _IM[@IM_page * MaxCharsPerLine..._IM.size] + ["·"]
      end
      x = 166
      for ch in @IM_chars
        textPositions.push([ch, x - 113 + PINYIN_X_OFFSET, 170 + PINYIN_Y_OFFSET, false, Color.new(248, 248, 248), Color.new(120, 120, 120)])
        x += 32
      end
      pbDrawTextPositions(bgoverlay, textPositions)
    end
  end

  alias orig_pbChangeTab pbChangeTab
  def pbChangeTab(newtab = @mode + 1)
    # QAQ
    @IM.init
    pbUpdateOverlay

    orig_pbChangeTab(newtab)
  end

  def pbUpdate
    for i in 0...@@Characters.length
      @bitmaps[i].update
    end
    if @init || Graphics.frame_count % 5 == 0
      @init = false
      cursorpos = @helper.cursor
      cursorpos = @maxlength - 1 if cursorpos >= @maxlength
      cursorpos = 0 if cursorpos < 0
      @maxlength.times { |i|
        # QAQ @blanks[i] = (i == cursorpos) ? 1 : 0
        @blanks[i] = (i >= cursorpos - @IM.value.size && i <= cursorpos) ? 1 : 0
        @sprites["blank#{i}"].y = [78, 82][@blanks[i]]
      }
    end
    pbDoUpdateOverlay
    pbUpdateSpriteHash(@sprites)
  end

  def pbMoveCursor
    oldcursor = @cursorpos
    cursordiv = @cursorpos / ROWS   # The row the cursor is in
    cursormod = @cursorpos % ROWS   # The column the cursor is in
    cursororigin = @cursorpos - cursormod
    if Input.repeat?(Input::LEFT)
      if @cursorpos < 0   # Controls
        @cursorpos -= 1
        @cursorpos = OK if @cursorpos < MODE1
      else
        begin
          cursormod = wrapmod(cursormod - 1, ROWS)
          @cursorpos = cursororigin + cursormod
        end while pbColumnEmpty?(cursormod)
      end
    elsif Input.repeat?(Input::RIGHT)
      if @cursorpos < 0   # Controls
        @cursorpos += 1
        @cursorpos = MODE1 if @cursorpos > OK
      else
        begin
          cursormod = wrapmod(cursormod + 1, ROWS)
          @cursorpos = cursororigin + cursormod
        end while pbColumnEmpty?(cursormod)
      end
    elsif Input.repeat?(Input::UP)
      if @cursorpos < 0         # Controls
        case @cursorpos
        when MODE1 then @cursorpos = ROWS * (COLUMNS - 1)
        when MODE2 then @cursorpos = ROWS * (COLUMNS - 1) + 2
        when MODE3 then @cursorpos = ROWS * (COLUMNS - 1) + 4
        when BACK  then @cursorpos = ROWS * (COLUMNS - 1) + 8
        when OK    then @cursorpos = ROWS * (COLUMNS - 1) + 11
        end
      elsif @cursorpos < ROWS   # Top row of letters
        case @cursorpos
        when 0, 1        then @cursorpos = MODE1
        when 2, 3        then @cursorpos = MODE2
        when 4, 5, 6     then @cursorpos = MODE3
        when 7, 8, 9, 10 then @cursorpos = BACK
        when 11, 12      then @cursorpos = OK
        end
      else
        cursordiv = wrapmod(cursordiv - 1, COLUMNS)
        @cursorpos = cursordiv * ROWS + cursormod
      end
    elsif Input.repeat?(Input::DOWN)
      if @cursorpos < 0                      # Controls
        case @cursorpos
        when MODE1 then @cursorpos = 0
        when MODE2 then @cursorpos = 2
        when MODE3 then @cursorpos = 4
        when BACK  then @cursorpos = 8
        when OK    then @cursorpos = 11
        end
      elsif @cursorpos >= ROWS * (COLUMNS - 1)   # Bottom row of letters
        case cursormod
        when 0, 1        then @cursorpos = MODE1
        when 2, 3        then @cursorpos = MODE2
        when 4, 5, 6     then @cursorpos = MODE3
        when 7, 8, 9, 10 then @cursorpos = BACK
        else                  @cursorpos = OK
        end
      else
        cursordiv = wrapmod(cursordiv + 1, COLUMNS)
        @cursorpos = cursordiv * ROWS + cursormod
      end
    end
    if @cursorpos != oldcursor   # Cursor position changed
      @sprites["cursor"].setCursorPos(@cursorpos)
      pbPlayCursorSE
      return true
    end
    return false
  end

  def pbEntry
    ret = ""
    loop do
      Graphics.update
      Input.update
      pbUpdate
      next if pbMoveCursor
      # QAQ
      if Input.trigger?(Input::SPECIAL)
        orig_pbChangeTab
      elsif Input.trigger?(Input::ACTION)
        @cursorpos = OK
        @sprites["cursor"].setCursorPos(@cursorpos)
      elsif Input.trigger?(Input::BACK) || Input.triggerex?(:BACKSPACE)
        @IM.back # QAQ
        @helper.delete
        pbPlayCancelSE
        @IM_page = 0 # QAQ
        pbUpdateOverlay
      elsif Input.trigger?(Input::USE)
        case @cursorpos
        when BACK   # Backspace
          @IM.back # QAQ
          @helper.delete
          pbPlayCancelSE
          @IM_page = 0 # QAQ
          pbUpdateOverlay
        when OK     # Done
          pbSEPlay("GUI naming confirm")
          if @helper.length >= @minlength
            ret = @helper.text
            break
          end
        when MODE1
          pbChangeTab(0) if @mode != 0
        when MODE2
          pbChangeTab(1) if @mode != 1
        when MODE3
          pbChangeTab(2) if @mode != 2
        else
          cursormod = @cursorpos % ROWS
          cursordiv = @cursorpos / ROWS
          charpos = cursordiv * ROWS + cursormod
          chset = @@Characters[@mode][0]
          if @helper.length >= @maxlength
            @helper.delete
          end
          # QAQ
          if @mode == 0
            if cursordiv == 0
              if cursormod == 0
                prevPage
              elsif cursormod == @IM_chars.size - 1
                nextPage
              elsif cursormod < @IM_chars.size - 1
                if !(@IM_page == 0 && cursormod == 1)
                  for j in 0...@IM.value.size
                    @helper.delete
                  end
                  @helper.insert(@IM_chars[cursormod])
                end
                @IM.init
              end
            else
              @IM_page = 0 # QAQ
              char = chset[charpos]
              if char == ""

              elsif char.match(/[A-Za-z]/)
                if @IM.add(char)
                  @helper.insert(chset[charpos].downcase)
                  $game_system.se_play($data_system.decision_se)
                else
                  @IM.init
                  $game_system.se_play($data_system.buzzer_se)
                end
              else
                @IM.init
                @helper.insert(chset[charpos].downcase)
                $game_system.se_play($data_system.decision_se)
              end
            end
          else
            @helper.insert(chset[charpos])
          end

          pbPlayCursorSE
          if @helper.length >= @maxlength
            @cursorpos = OK
            @sprites["cursor"].setCursorPos(@cursorpos)
          end
          pbUpdateOverlay
        end
      end
    end
    Input.update
    return ret
  end
end