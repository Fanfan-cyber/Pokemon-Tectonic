class UI_Custom
  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height) # 512 * 384
    @viewport.z = 99_999
    @sprites = {}
    @party = $Trainer.party
    @selection = 0
    background_path = nil

    if background_path
      @sprites["background"] = IconSprite.new(0, 0, @viewport)
      @sprites["background"].setBitmap(background_path)
    end

    add_Sprite

    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["overlay"].z = @viewport.z + 99
    set_system_font("overlay")
    draw_text

    main_loop
  end

  def add_Sprite
    # PokemonIconSprite.new(pkmn, @viewport)
    # PokemonSpeciesIconSprite(species, @viewport)
    # ItemIconSprite.new(0, 0, item, @viewport)
    # HeldItemIconSprite.new(0, 0, item, @viewport)
    # PokemonSprite.new(@viewport) setSpeciesBitmap(species)

    @sprites["sprite_1"] = IconSprite.new(0, 0, @viewport)
    @sprites["sprite_1"].setBitmap("Graphics/UI/a")

    @sprites["animated_1"] = AnimatedSprite.create("Graphics/UI/a", 4, 3, @viewport)
    @sprites["animated_1"].start
  end

  def draw_text(text = nil)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    text_pos = []
    base_color = Color.new(248, 248, 248)
    shadow_color = Color.new(64, 64, 64)

    text_pos.push([_INTL(""), 0, 0, 0, base_color, shadow_color])
    text_pos.push([_INTL("GF"), 0, 0, 1, base_color, shadow_color])
    text_pos.push([_INTL("Game Freak"), 0, 0, 2, base_color, shadow_color])

    pbDrawTextPositions(overlay, text_pos)

    #text = _INTL("")
    drawTextEx(overlay, 0, 0, Graphics.width, 12, text, base_color, shadow_color) if text # 32 * 12
  end

  def main_loop
    pbFadeInAndShow(@sprites)

    loop do
      Graphics.update
      Input.update
      pbUpdate
      old_selection = @selection
      if Input.trigger?(Input::USE)
        pbPlayDecisionSE
        break
      elsif Input.trigger?(Input::BACK)
        pbPlayCancelSE
        break
      elsif Input.trigger?(Input::UP)
        @selection += 0
      elsif Input.trigger?(Input::DOWN)
        @selection += 0
      elsif Input.trigger?(Input::LEFT)
        @selection += 0
      elsif Input.trigger?(Input::RIGHT)
        @selection += 0
      end
      @selection = @selection.clamp(0, 999)
      if @selection != old_selection
        pbPlayCursorSE
        # do some thing
      end
    end

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    result
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def result
    @selection
  end

  def set_system_font(sprite)
    pbSetSystemFont(@sprites[sprite].bitmap)
  end

  def set_small_font(sprite)
    pbSetSmallFont(@sprites[sprite].bitmap)
  end

  def font_size(sprite, size = 29)
    @sprites[sprite].bitmap.font.size = size
  end

  def to_center(sprite)
    @sprites[sprite].x = (Graphics.width - @sprites[sprite].bitmap.width) / 2
    @sprites[sprite].y = (Graphics.height - @sprites[sprite].bitmap.height) / 2
  end

  def to_center_x(sprite)
    @sprites[sprite].x = (Graphics.width - @sprites[sprite].bitmap.width) / 2
  end

  def to_center_y(sprite)
    @sprites[sprite].y = (Graphics.height - @sprites[sprite].bitmap.height) / 2
  end

  def set_opacity(sprite, opacity = 255)
    @sprites[sprite].opacity = opacity
  end
end

def display_custom_ui
  UI_Custom.new
end