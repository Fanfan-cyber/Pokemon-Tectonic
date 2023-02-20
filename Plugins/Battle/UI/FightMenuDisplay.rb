class FightMenuDisplay < BattleMenuBase
  attr_reader :extraInfoToggled

  def initialize(viewport,z)
    super(viewport)
    self.x = 0
    self.y = Graphics.height-96
    @battler   = nil
    @shiftMode = 0
	  @extraInfoToggled = false
    # NOTE: @mode is for the display of the Mega Evolution button.
    #       0=don't show, 1=show unpressed, 2=show pressed
    if USE_GRAPHICS
      # Create bitmaps
      @buttonBitmap  			    = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_fight"))
      @typeBitmap    			    = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      @megaEvoBitmap 			    = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_mega"))
      @shiftBitmap   			    = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_shift"))
      @moveInfoDisplayBitmap  = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/move_info_display"))
      @ppUsageUpBitmap        = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/pp_usage_up"))
      @cursorShadeBitmap      = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_fight_shade"))
      # Create background graphic
      background = IconSprite.new(0,Graphics.height-96,viewport)
      background.setBitmap("Graphics/Pictures/Battle/overlay_fight")
      addSprite("background",background)
      # Create move buttons and highlighters
      @buttons = []
      @highlights = []
      @shaders = []
      for i in 0..Pokemon::MAX_MOVES do
        newButton = SpriteWrapper.new(viewport)
        newButton.bitmap = @buttonBitmap.bitmap
        buttonX = self.x + 4 + (((i%2)==0) ? 0 : @buttonBitmap.width/2-4)
        newButton.x      = buttonX
        buttonY = self.y + 6 + (((i/2)==0) ? 0 : BUTTON_HEIGHT-4)
        newButton.y      = buttonY
        newButton.src_rect.width  = @buttonBitmap.width/2
        newButton.src_rect.height = BUTTON_HEIGHT
        addSprite("button_#{i}",newButton)
        @buttons.push(newButton)

        newHighlighter = AnimatedSprite.new(["Graphics/Pictures/Battle/cursor_fight_highlight",37,0.5])
        newHighlighter.viewport = viewport
        newHighlighter.x = buttonX + 20
        newHighlighter.y = buttonY + 8
        newHighlighter.opacity = 80
        newHighlighter.blend_type = 1
        addSprite("highlight_#{i}",newHighlighter)
        @highlights.push(newHighlighter)

        newShader = SpriteWrapper.new(viewport)
        newShader.bitmap = @cursorShadeBitmap.bitmap
        newShader.x = buttonX + 20
        newShader.y = buttonY + 8
        newShader.opacity = 80
        addSprite("shader_#{i}",newShader)
        @shaders.push(newShader)
      end
      
      # Create overlay for buttons (shows move names)
      @overlay = BitmapSprite.new(Graphics.width,Graphics.height-self.y,viewport)
      @overlay.x = self.x
      @overlay.y = self.y
      pbSetNarrowFont(@overlay.bitmap)
      addSprite("overlay",@overlay)
      # Create overlay for selected move's info (shows move's PP)
      @infoOverlay = BitmapSprite.new(Graphics.width,Graphics.height-self.y,viewport)
      @infoOverlay.x = self.x
      @infoOverlay.y = self.y
      pbSetNarrowFont(@infoOverlay.bitmap)
      addSprite("infoOverlay",@infoOverlay)
      # Create type icon
      @typeIcon = SpriteWrapper.new(viewport)
      @typeIcon.bitmap = @typeBitmap.bitmap
      @typeIcon.x      = self.x+416
      @typeIcon.y      = self.y+20
      @typeIcon.src_rect.height = TYPE_ICON_HEIGHT
      addSprite("typeIcon",@typeIcon)
      # Create Mega Evolution button
      @megaButton = SpriteWrapper.new(viewport)
      @megaButton.bitmap = @megaEvoBitmap.bitmap
      @megaButton.x      = self.x+120
      @megaButton.y      = self.y-@megaEvoBitmap.height/2
      @megaButton.src_rect.height = @megaEvoBitmap.height/2
      addSprite("megaButton",@megaButton)
      # Create Shift button
      @shiftButton = SpriteWrapper.new(viewport)
      @shiftButton.bitmap = @shiftBitmap.bitmap
      @shiftButton.x      = self.x+4
      @shiftButton.y      = self.y-@shiftBitmap.height
      addSprite("shiftButton",@shiftButton)
      # Create extra info reminder button
      # @extraReminder = SpriteWrapper.new(viewport)
      # @extraReminder.bitmap = @extraReminderBitmap.bitmap
      # @extraReminder.x = self.x+4
      # @extraReminder.y = self.y + 6 - @extraReminderBitmap.height
      # addSprite("extraReminder",@extraReminder)
      # Create the move extra info display
      moveInfoDisplayY = self.y-@moveInfoDisplayBitmap.height
      @moveInfoDisplay = SpriteWrapper.new(viewport)
      @moveInfoDisplay.bitmap = @moveInfoDisplayBitmap.bitmap
      @moveInfoDisplay.x      = self.x
      @moveInfoDisplay.y      = moveInfoDisplayY
      addSprite("moveInfoDisplay",@moveInfoDisplay)
	    # Create overlay for selected move's extra info (shows move's BP, description)
      @extraInfoOverlay = BitmapSprite.new(@moveInfoDisplayBitmap.bitmap.width,@moveInfoDisplayBitmap.height,viewport)
      @extraInfoOverlay.x = self.x
      @extraInfoOverlay.y = moveInfoDisplayY
      pbSetNarrowFont(@extraInfoOverlay.bitmap)
      addSprite("extraInfoOverlay",@extraInfoOverlay)
    else
      # Create message box (shows type and PP of selected move)
      @msgBox = Window_AdvancedTextPokemon.newWithSize("",
         self.x+320,self.y,Graphics.width-320,Graphics.height-self.y,viewport)
      @msgBox.baseColor   = TEXT_BASE_COLOR
      @msgBox.shadowColor = TEXT_SHADOW_COLOR
      pbSetNarrowFont(@msgBox.contents)
      addSprite("msgBox",@msgBox)
      # Create command window (shows moves)
      @cmdWindow = Window_CommandPokemon.newWithSize([],
         self.x,self.y,320,Graphics.height-self.y,viewport)
      @cmdWindow.columns       = 2
      @cmdWindow.columnSpacing = 4
      @cmdWindow.ignore_input  = true
      pbSetNarrowFont(@cmdWindow.contents)
      addSprite("cmdWindow",@cmdWindow)
    end
    self.z = z
  end

  def dispose
    super
    @buttonBitmap.dispose if @buttonBitmap
    @typeBitmap.dispose if @typeBitmap
    @megaEvoBitmap.dispose if @megaEvoBitmap
    @shiftBitmap.dispose if @shiftBitmap
	  #@extraReminderBitmap if @extraReminderBitmap
	  @moveInfoDisplayBitmap.dispose if @moveInfoDisplayBitmap
    @ppUsageUpBitmap.dispose if @ppUsageUpBitmap
  end

  def z=(value)
    super
    @msgBox.z      += 1 if @msgBox
    @cmdWindow.z   += 2 if @cmdWindow
    @overlay.z     += 5 if @overlay
    @infoOverlay.z += 6 if @infoOverlay
    @typeIcon.z    += 1 if @typeIcon
    @highlights.each do |highlight|
      highlight.z += 6
    end
    @shaders.each do |highlight|
      highlight.z += 7
    end
  end
  
  def visible=(value)
    super(value)
	  @sprites["moveInfoDisplay"].visible = @extraInfoToggled && @visible if @sprites["moveInfoDisplay"]
	  @sprites["extraInfoOverlay"].visible = @extraInfoToggled && @visible if @sprites["moveInfoDisplay"]
	  #@sprites["extraReminder"].visible = !@extraInfoToggled && @visible if @sprites["extraReminder"]
  end
  
  def toggleExtraInfo
    @extraInfoToggled = !@extraInfoToggled
    @sprites["moveInfoDisplay"].visible = @extraInfoToggled && @visible if @sprites["moveInfoDisplay"]
    @sprites["extraInfoOverlay"].visible = @extraInfoToggled && @visible if @sprites["moveInfoDisplay"]
    #@sprites["extraReminder"].visible = !@extraInfoToggled && @visible if @sprites["extraReminder"]
  end

  def refreshButtonNames
    moves = (@battler) ? @battler.moves : []
    if !USE_GRAPHICS
      # Fill in command window
      commands = []
      for i in 0...[4, moves.length].max
        commands.push((moves[i]) ? moves[i].name : "-")
      end
      @cmdWindow.commands = commands
      return
    end
    # Draw move names onto overlay
    @overlay.bitmap.clear
    textPos = []
    @buttons.each_with_index do |button,i|
      @visibility["highlight_#{i}"] = false
      @visibility["shader_#{i}"] = false
      next if !@visibility["button_#{i}"]
      move = moves[i]
      x = button.x-self.x+button.src_rect.width/2
      y = button.y-self.y+2
      moveNameBase = TEXT_BASE_COLOR
      if move.type
        # NOTE: This takes a colour from a particular pixel in the button
        #       graphic and makes the move name's base colour that same colour.
        #       The pixel is at coordinates 10,34 in the button box. If you
        #       change the graphic, you may want to change/remove the below line
        #       of code to ensure the font is an appropriate colour.
        moveNameBase = button.bitmap.get_pixel(10,button.src_rect.y+34)
      end
      textPos.push([move.name,x,y,2,moveNameBase,TEXT_SHADOW_COLOR])
      begin
        # Determine whether to shade the move
        targetingData = move.pbTarget(@battler)
        @battler.turnCount += 1 # Fake the turn count
        if targetingData.num_targets == 0 || move.worksWithNoTargets?
          shouldShade = move.shouldShade?(@battler,nil)
        else
          shouldShade = true
          @battler.battle.eachBattler do |otherBattler|
            next unless @battler.battle.pbMoveCanTarget?(@battler.index,otherBattler.index,targetingData)
            next if move.shouldShade?(@battler,otherBattler)
            shouldShade = false
            break
          end
        end
        @battler.turnCount -= 1 # Fake the turn count

        if shouldShade
          @visibility["shader_#{i}"] = true
        # Determine whether to highlight the move
        elsif move.damagingMove?
          shouldHighlight = false

          if targetingData.num_targets == 0
            shouldHighlight = move.shouldHighlight?(user,nil)
          else
            @battler.eachOpposing do |opposingBattler|
              next unless @battler.battle.pbMoveCanTarget?(@battler.index,opposingBattler.index,targetingData)
              next unless move.shouldHighlight?(@battler,opposingBattler)
              shouldHighlight = true
              break
            end
          end
  
          if shouldHighlight
            @visibility["highlight_#{i}"] = true
            @sprites["highlight_#{i}"].start
          end
        end
      rescue
        echoln("Error computing shading and highlighting for move #{move.name}")
      end
    end
    pbDrawTextPositions(@overlay.bitmap,textPos)
    @buttons.each_with_index do |button,i|
      next if !@visibility["button_#{i}"]
      if PP_INCREASE_REPEAT_MOVES
        if @battler && @battler.lastMoveUsed && @battler.lastMoveUsed == moves[i].id && !@battler.lastMoveFailed
          x = button.x-self.x+button.src_rect.width - 32
          y = button.y-self.y+4
          @overlay.bitmap.blt(x,y+2,@ppUsageUpBitmap.bitmap,Rect.new(0,0,@ppUsageUpBitmap.width,@ppUsageUpBitmap.height))
        end
      end
    end
  end

  EFFECTIVENESS_SHADOW_COLOR = Color.new(160, 160, 168)

  def refreshMoveData(move)
    # Write PP and type of the selected move
    if !USE_GRAPHICS
      moveType = GameData::Type.get(move.type).name
      if move.total_pp<=0
        @msgBox.text = _INTL("PP: ---<br>TYPE/{1}",moveType)
      else
        @msgBox.text = _ISPRINTF("PP: {1: 2d}/{2: 2d}<br>TYPE/{3:s}",
           move.pp,move.total_pp,moveType)
      end
      return
    end
    @infoOverlay.bitmap.clear
    if !move
      @visibility["typeIcon"] = false
      return
    end
    @visibility["typeIcon"] = true
    # Type icon
    type_number = GameData::Type.get(move.type).id_number
    @typeIcon.src_rect.y = type_number * TYPE_ICON_HEIGHT
    # PP text
    # if move.total_pp>0
    #   ppFraction = [(4.0*move.pp/move.total_pp).ceil,3].min
    #   textPosPP = []
    #   textPosPP.push([_INTL("PP: {1}/{2}",move.pp,move.total_pp),
    #      448,44,2,PP_COLORS[ppFraction*2],PP_COLORS[ppFraction*2+1]])
    #   pbDrawTextPositions(@infoOverlay.bitmap,textPosPP)
    # end
    
    effectivenessTextPos = nil
    effectivenessTextX = 448
    effectivenessTextY = 44
    if move.damagingMove?
      begin
        if move.is_a?(PokeBattle_FixedDamageMove)
          effectivenessDescription = "Neutral"
          effectivenessColor = EFFECTIVENESS_COLORS[3]
        else
          typeOfMove = move.pbCalcType(@battler)
          targetingData = move.pbTarget(@battler)
          maxEffectiveness = 0
          @battler.eachOpposing do |opposingBattler|
            next if !@battler.battle.pbMoveCanTarget?(@battler.index,opposingBattler.index,targetingData)
            effectiveness = move.pbCalcTypeMod(typeOfMove,@battler,opposingBattler,true)
            maxEffectiveness = effectiveness if effectiveness > maxEffectiveness
          end

          ration = maxEffectiveness/Effectiveness::NORMAL_EFFECTIVE.to_f
          case ration
          when 0              then effectivenessCategory = 0
          when 0.00001..0.25  then effectivenessCategory = 1
          when 0.5 	          then effectivenessCategory = 2
          when 1 		    	    then effectivenessCategory = 3
          when 2 			        then effectivenessCategory = 4
          when 4.. 			      then effectivenessCategory = 5
          end

          effectivenessDescription = [_INTL("No Effect"),_INTL("Barely"),_INTL("Not Very"),_INTL("Neutral"),_INTL("Super"),_INTL("Hyper"),_INTL("Hyper")][effectivenessCategory]
          effectivenessColor = EFFECTIVENESS_COLORS[effectivenessCategory]
        end
        
        effectivenessTextPos = [effectivenessDescription,effectivenessTextX,effectivenessTextY,2,
          effectivenessColor,EFFECTIVENESS_SHADOW_COLOR]
      rescue
        effectivenessTextPos = ["ERROR",effectivenessTextX,44,2,TEXT_BASE_COLOR,TEXT_SHADOW_COLOR]
      end

      # Apply a highlight to moves that are in an extra useful state
    else
      effectivenessTextPos = ["Status",effectivenessTextX,44,2,TEXT_BASE_COLOR,TEXT_SHADOW_COLOR]
    end

    pbDrawTextPositions(@infoOverlay.bitmap,[effectivenessTextPos]) if !effectivenessTextPos.nil?
	
    # Extra move info display
    @extraInfoOverlay.bitmap.clear
    overlay = @extraInfoOverlay.bitmap
    selected_move = GameData::Move.get(move.id)
    
    # Write power and accuracy values for selected move
    # Write various bits of text
    base   = Color.new(248,248,248)
    shadow = Color.new(104,104,104)
    textpos = [
       [_INTL("CATEGORY"),20,0,0,base,shadow],
       [_INTL("POWER"),20,32,0,base,shadow],
       [_INTL("ACCURACY"),20,64,0,base,shadow],
       [_INTL("PP"),20,96,0,base,shadow]
    ]
	
    base = Color.new(64,64,64)
    shadow = Color.new(176,176,176)
    case selected_move.base_damage
    when 0 then textpos.push(["---", 220, 32, 1, base, shadow])   # Status move
    when 1 then textpos.push(["???", 220, 32, 1, base, shadow])   # Variable power move
    else        textpos.push([selected_move.base_damage.to_s, 220, 32, 2, base, shadow])
    end
    if selected_move.accuracy == 0
      textpos.push(["---", 220, 64, 1, base, shadow])
    else
      textpos.push(["#{selected_move.accuracy}%", 220, 64, 2, base, shadow])
    end
    if selected_move.total_pp>0
      ppFraction = [(4.0*move.pp/move.total_pp).ceil,3].min
      textpos.push([_INTL("{1}/{2}",move.pp,move.total_pp),
        220,96,2,PP_COLORS[ppFraction*2],PP_COLORS[ppFraction*2+1]])
    end
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Draw selected move's damage category icon
    imagepos = [["Graphics/Pictures/category", 192, 8, 0, selected_move.category * 28, 64, 28]]
    pbDrawImagePositions(overlay, imagepos)
	  # Draw selected move's description
	  drawTextEx(overlay,8,140,264,4,selected_move.description,base,shadow)
  end
end

class AnimatedSprite
  # Shorter version of AnimationSprite.  All frames are placed on a single row
  # of the bitmap, so that the width and height need not be defined beforehand
  def initializeShort(animname,framecount,frameskip)
    @animname=pbBitmapName(animname)
    @realframes=0
    @frameskip = frameskip * Graphics.frame_rate/20
    @frameskip= 1 if @frameskip < 1
    begin
      @animbitmap=AnimatedBitmap.new(animname).deanimate
    rescue
      @animbitmap=Bitmap.new(framecount*4,32)
    end
    if @animbitmap.width%framecount!=0
      raise _INTL("Bitmap's width ({1}) is not a multiple of frame count ({2}) [Bitmap={3}]",
         @animbitmap.width,framewidth,animname)
    end
    @framecount=framecount
    @framewidth=@animbitmap.width/@framecount
    @frameheight=@animbitmap.height
    @framesperrow=framecount
    @playing=false
    self.bitmap=@animbitmap
    self.src_rect.width=@framewidth
    self.src_rect.height=@frameheight
    self.frame=0
  end
end