class WhoAmI_Scene
  WHITE = Color.new(248, 248, 248)
  SHADOW = Color.new(64, 64, 64)
  YELLOW = Color.new(255, 248, 64)
  BROWN = Color.new(72, 64, 16)

  SPECIES = GameData::Species.keys

  def initialize
    @viewport      = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z    = 9998
    @sprites       = {}
    @sprites["bg"] = IconSprite.new(0, 0, @viewport)
    @sprites["bg"].setBitmap("Graphics/Pictures/Who am I")
    
    @player = $Trainer
  end

  def pbStartScreen
    loop do
      setup_game
      run_game_loop
      display_results
      break unless wait_for_input
      dispose_overlay
    end
  end

  def setup_game
    pbMEPlay("Who am I Q")

    @species_arr = SPECIES.sample(3)
    @names = @species_arr.map { |s| GameData::Species.get(s).name }

    @species = @species_arr.sample
    @real_species = GameData::Species.get(@species).species
    @name = GameData::Species.get(@species).name

    @selection = 0
    setup_sprites
  end

  def setup_sprites
    @sprites["pokesprite"] = PokemonSprite.new(@viewport)
    @sprites["pokesprite"].setSpeciesBitmap(@real_species)
    @sprites["pokesprite"].tone = Tone.new(-255, -255, -255)
    @sprites["pokesprite"].x = 144
    @sprites["pokesprite"].y = 144
    @sprites["pokesprite"].z = @viewport.z + 2

    @sprites["info"] = BitmapSprite.new(Graphics.width, Graphics.height)
    @sprites["info"].z = @viewport.z + 3
    draw_info_text

    @sprites["text"] = BitmapSprite.new(Graphics.width, Graphics.height)
    @sprites["text"].z = @viewport.z + 3
    draw_text_options
  end

  def draw_info_text
    infopos = [
      [_INTL("金钱:{1}", @player.money), 8, 8, false, WHITE, SHADOW, 1],
      [_INTL("发现图鉴:{1}", @player.pokedex.seen_count), Graphics.width - 8, 8, true, WHITE, SHADOW, 1],
      [_INTL("? ? ? ?"), 380, 120, 2, YELLOW, BROWN, 1],
      [_INTL("我是谁"), 380, 150, 2, YELLOW, BROWN, 1],
      [_INTL("[←]:左移  [→]:右移  [C]:确认"), Graphics.width / 2, Graphics.height - 32, 2, WHITE, SHADOW, 1]
    ]
    pbSetSystemFont(@sprites["info"].bitmap)
    pbDrawTextPositions(@sprites["info"].bitmap, infopos)
  end

  def draw_text_options
    @textpos = [
      [_INTL("{1}", @names[0]), Graphics.width / 2 - 150, 300, 2, YELLOW, BROWN, 1],
      [_INTL("{1}", @names[1]), Graphics.width / 2, 300, 2, WHITE, SHADOW, 1],
      [_INTL("{1}", @names[2]), Graphics.width / 2 + 150, 300, 2, WHITE, SHADOW, 1]
    ]
    pbSetSystemFont(@sprites["text"].bitmap)
    pbDrawTextPositions(@sprites["text"].bitmap, @textpos)
  end

  def run_game_loop
    loop do
      Graphics.update
      Input.update
      handle_input
      update_text_highlight
      break if Input.trigger?(Input::USE) && pbConfirmMessage(_INTL("确定要选择{1}吗？", @textpos[@selection][0]))
      break if @press_back
    end
  end

  def handle_input
    if Input.trigger?(Input::BACK)
      @press_back = true
    elsif Input.trigger?(Input::LEFT)
      @selection = @selection == 0 ? 2 : @selection - 1
      pbSEPlay("GUI sel decision")
    elsif Input.trigger?(Input::RIGHT)
      @selection = @selection == 2 ? 0 : @selection + 1
      pbSEPlay("GUI sel decision")
    end
  end

  def update_text_highlight
    @textpos = [
      [_INTL("{1}", @names[0]), Graphics.width / 2 - 150, 300, 2, WHITE, SHADOW, 1],
      [_INTL("{1}", @names[1]), Graphics.width / 2, 300, 2, WHITE, SHADOW, 1],
      [_INTL("{1}", @names[2]), Graphics.width / 2 + 150, 300, 2, WHITE, SHADOW, 1]
    ]
    @textpos[@selection][4] = YELLOW
    @textpos[@selection][5] = BROWN
    @sprites["text"].bitmap.clear
    pbSetSystemFont(@sprites["text"].bitmap)
    pbDrawTextPositions(@sprites["text"].bitmap, @textpos)
  end

  def display_results
    @player.pokedex.set_seen(@species)
    pbMEPlay("Who am I A")
    @sprites["text"].bitmap.clear
    @sprites["info"].bitmap.clear

    if !@press_back && @species_arr[@selection] == @species
      msg = _INTL("恭喜你，猜对了!")
      @player.money += 500
    else
      msg = _INTL("很遗憾，猜错了!")
    end
    @press_back = false
    infopos = [
      [_INTL("{1}", @name), 380, 120, 2, YELLOW, BROWN, 1],
      [_INTL("金钱:{1}", @player.money), 8, 8, false, WHITE, SHADOW, 1],
      [_INTL("发现图鉴:{1}", @player.pokedex.seen_count), Graphics.width - 8, 8, true, WHITE, SHADOW, 1],
      [_INTL("{1}", msg), 380, 192, 2, WHITE, SHADOW, 1],
      [_INTL("[C]:继续  [X]:退出"), Graphics.width / 2, Graphics.height - 32, 2, WHITE, SHADOW, 1]
    ]
    pbSetSystemFont(@sprites["info"].bitmap)
    pbDrawTextPositions(@sprites["info"].bitmap, infopos)
    animate_reveal
  end

  def animate_reveal
    4.times do |i|
      value = -256 + (i + 1) * 64
      @sprites["pokesprite"].tone = Tone.new(value, value, value)
    end
  end

  def wait_for_input
    loop do
      Graphics.update
      Input.update
      return true if Input.trigger?(Input::USE)
      return false if Input.trigger?(Input::BACK)
    end
  end

  def dispose_overlay
    @sprites["pokesprite"].dispose
    @sprites["info"].dispose
    @sprites["text"].dispose
  end
  
  def pbEndScreen
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class WhoAmIScreen
  def initialize(scene)
    @scene = scene
  end

  def pbShowScreen
    @scene.pbStartScreen
    @scene.pbEndScreen
  end
end

def whoAmI
  pbFadeOutIn(9997) do
    scene = WhoAmI_Scene.new
    screen = WhoAmIScreen.new(scene)
    screen.pbShowScreen
  end
end