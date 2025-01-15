class WhoAmI_Scene
  WHITE  = Color.new(248, 248, 248)
  SHADOW = Color.new(64, 64, 64)
  YELLOW = Color.new(255, 248, 64)
  BROWN  = Color.new(72, 64, 16)

  def initialize
    @viewport      = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z    = 9998
    @sprites       = {}
    @sprites["bg"] = IconSprite.new(0, 0, @viewport)
    @sprites["bg"].setBitmap("Graphics/Pictures/Who am I")
    
    @player = $Trainer
    @language = Settings::LANGUAGES[$PokemonSystem.language][0]
    @all_species = GameData::Species.keys
  end

  def chinese?
    @language == "Simplified Chinese"
  end

  def pbStartScreen
    loop do
      setup_game
      break unless run_game_loop
      display_results
      break unless wait_for_input
      dispose_overlay
    end
  end

  def setup_game
    if chinese?
      pbMEPlay("Who am I Q")
    else
      pbMEPlay("Who am I Q")
    end

    @species_arr = @all_species.sample(3)
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
      [_INTL("Money: {1}", @player.money), 8, 0, false, WHITE, SHADOW, 1],
      #[_INTL("Pokédex Seen: {1}", @player.pokedex.seen_count), Graphics.width - 18, 0, true, WHITE, SHADOW, 1],
      [_INTL("Correct: {1}   Incorrect: {2}", @player.get_ta(:who_am_i_correct, 0), @player.get_ta(:who_am_i_incorrect, 0)), Graphics.width - 18, 0, true, WHITE, SHADOW, 1],
      [_INTL("? ? ? ?"), 380, 120, 2, YELLOW, BROWN, 1],
      [_INTL("[←]: Move Left   [→]: Move Right   [C]: Confirm"), Graphics.width / 2, Graphics.height - 42, 2, WHITE, SHADOW, 1]
    ]
    if chinese?
      infopos.push([_INTL("Who am I ?"), 380, 150, 2, YELLOW, BROWN, 1])
    else
      infopos.push([_INTL("Who's that Pokémon?"), 380, 150, 2, YELLOW, BROWN, 1])
    end
    pbSetSystemFont(@sprites["info"].bitmap)
    pbDrawTextPositions(@sprites["info"].bitmap, infopos)
  end

  def draw_text_options
    @textpos = [
      [@names[0], Graphics.width / 2 - 150, 300, 2, YELLOW, BROWN, 1],
      [@names[1], Graphics.width / 2, 300, 2, WHITE, SHADOW, 1],
      [@names[2], Graphics.width / 2 + 150, 300, 2, WHITE, SHADOW, 1]
    ]
    pbSetSystemFont(@sprites["text"].bitmap)
    pbDrawTextPositions(@sprites["text"].bitmap, @textpos)
  end

  def check_entering_limit
    if @player.money < LEAST_MONEY
      pbMessage(_INTL("You don't have enough money to play the game!"))
      return false
    end
    return true
  end

  def run_game_loop
    loop do
      Graphics.update
      Input.update
      handle_input
      update_text_highlight
      return false if @press_back
      if Input.trigger?(Input::USE)
        return false if !check_entering_limit
        return true if pbConfirmMessage(_INTL("Are you sure you want to select {1}?", @names[@selection]))
      end
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
      [@names[0], Graphics.width / 2 - 150, 300, 2, WHITE, SHADOW, 1],
      [@names[1], Graphics.width / 2, 300, 2, WHITE, SHADOW, 1],
      [@names[2], Graphics.width / 2 + 150, 300, 2, WHITE, SHADOW, 1]
    ]
    @textpos[@selection][4] = YELLOW
    @textpos[@selection][5] = BROWN
    @sprites["text"].bitmap.clear
    pbSetSystemFont(@sprites["text"].bitmap)
    pbDrawTextPositions(@sprites["text"].bitmap, @textpos)
  end

  def display_results
    if chinese?
      pbMEPlay("Who am I A")
    else
      pbMEPlay("Who am I A")
    end
    @sprites["text"].bitmap.clear
    @sprites["info"].bitmap.clear

    if !@press_back && @species_arr[@selection] == @species
      msg = _INTL("You got it right!")
      apply_award
    else
      msg = _INTL("Sorry, you got it wrong!")
      apply_award(false)
    end
    @press_back = false
    infopos = [
      [_INTL("{1}", @name), 380, 120, 2, YELLOW, BROWN, 1],
      [_INTL("Money: {1}", @player.money), 8, 0, false, WHITE, SHADOW, 1],
      #[_INTL("Pokédex Seen: {1}", @player.pokedex.seen_count), Graphics.width - 18, 0, true, WHITE, SHADOW, 1],
      [_INTL("Correct: {1}   Incorrect: {2}", @player.get_ta(:who_am_i_correct), @player.get_ta(:who_am_i_incorrect)), Graphics.width - 18, 0, true, WHITE, SHADOW, 1],
      [_INTL("{1}", msg), 380, 192, 2, WHITE, SHADOW, 1],
      [_INTL("[C]: Continue   [X]: Exit"), Graphics.width / 2, Graphics.height - 42, 2, WHITE, SHADOW, 1]
    ]
    pbSetSystemFont(@sprites["info"].bitmap)
    pbDrawTextPositions(@sprites["info"].bitmap, infopos)
    animate_reveal
  end

  AWARD_MONEY = 500
  LOST_MONEY  = 500
  LEAST_MONEY = 500

  def apply_award(correct = true)
    if correct 
      @player.money += AWARD_MONEY
      @player.increase_ta(:who_am_i_correct)
    else
      @player.money = [0, @player.money - LOST_MONEY].max
      @player.increase_ta(:who_am_i_incorrect)
    end
    #@player.pokedex.set_seen(@species)
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
      if Input.trigger?(Input::USE)
        return true if check_entering_limit
        return false
      end
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