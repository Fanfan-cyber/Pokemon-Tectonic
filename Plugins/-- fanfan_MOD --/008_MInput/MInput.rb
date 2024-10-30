#===============================================================================#
#                             Marin's Input Module                              #
#                                  by Marin                                     #
#===============================================================================#
#   Easier to get input from specific buttons, and you have better options in   #
#   terms of input-checking. You can test for a button to be triggered once,    #
#  repeatedly (with a specific interval), or if the button is currently being   #
#                                   pressed.                                    #
#===============================================================================#
# .trigger?(keys)              : Returns true when the key is first pressed.    #
# .repeat?(keys, interval = 2 ) : Returns true when the key is first pressed,   #
#                                and then returns true every 'interval' frames. #
# .press?(keys)                : Returns true if the key is currently being     #
#                                held down.                                     #
#===============================================================================#
#                    Please give credit when using this.                        #
#===============================================================================#

module MInput
  @@RepeatCalls = {}
  @@TriggerCalls = {}

  def self.RepeatCalls; @@RepeatCalls; end
  def self.TriggerCalls; @@TriggerCalls; end

  # Updates all intervals/countdowns
  def self.update
    @@RepeatCalls.keys.each do |e|
      @@RepeatCalls[e] -= 1
      if @@RepeatCalls[e] == -1
        @@RepeatCalls.delete(e)
      end
    end
    @@TriggerCalls.keys.each do |e|
      @@TriggerCalls[e] = nil unless MInput.press?(*e)
    end
  end

  # Let's say you pass .repeat? an interval of 8
  # The first time you hit the button, it returns true
  # You then have to wait 'DefaultWaitTimeForInteval' amount of frames
  # It then returns true based on your interval.
  DefaultWaitTimeForInteval = 20

  class MInputError < StandardError; end

  # Creates shortcuts methods for these keys
  # e.g:
  #   :confirm => [:C, :RTRN, :RETURN, :ENTER, :SPC, :SPACE, :SPACEBAR] is equivalent to MInput.trigger?(:C, :RETURN)
  # Which creates this shortcut:
  #   MInput.confirm?
  SHORTCUTS = {
    :confirm? => [:C, :RTRN, :RETURN, :ENTER, :SPC, :SPACE, :SPACEBAR],
    :cancel?  => [:X, :BACKSPACE, :ESC],
    :up?      => :UP,
    :down?    => :DOWN,
    :left?    => :LEFT,
    :right?   => :RIGHT,

    :extra_move_1? => [:NUMPAD1, :NUM1, :N1, :ONE],
    :extra_move_2? => [:NUMPAD2, :NUM2, :N2, :TWO],
    :extra_move_3? => [:NUMPAD3, :NUM3, :N3, :THREE],
    :extra_move_4? => [:NUMPAD4, :NUM4, :N4, :FOUR]
  }

  # Standard keys that can be used in .trigger?, .press?, .repeat?
  STD = {
      [:MOUSE_LEFT, :LEFT_MOUSE]     => 0x01,
      [:MOUSE_RIGHT, :RIGHT_MOUSE]   => 0x02,
      [:MOUSE_MIDDLE, :MIDDLE_MOUSE] => 0x04,
      :BACKSPACE                     => 0x08,
      [:TAB, :TABSPACE]              => 0x09,
      [:RTRN, :RETURN, :ENTER]       => 0x0D,
      [:SHFT, :SHIFT]                => 0x10,
      [:CTRL, :CONTROL]              => 0x11,
      :ALT                           => 0x12,
      [:PSE, :PAUSE, :BRK, :BREAK]   => 0x13,
      [:CAPS, :CAPSLOCK]             => 0x14,
      [:ESC, :ESCAPE]                => 0x1B,
      [:SPC, :SPACE, :SPACEBAR]              => 0x20,
      [:PGUP, :PAGEUP]                       => 0x21,
      [:PGDWN, :PGDOWN, :PAGEDWN, :PAGEDOWN] => 0x22,
      :END                                   => 0x23,
      :HOME                                  => 0x24,
      [:LEFT, :LARROW, :LARW, :LEFTARROW]    => 0x25,
      [:UP, :UPARROW, :UPARW]                => 0x26,
      [:RIGHT, :RARROW, :RARW, :RIGHARROW]   => 0x27,
      [:DOWN, :DARROW, :DARW, :DOWNARROW]    => 0x28,
      [:INS, :INSRT, :INSERT]                => 0x2D,
      [:DEL, :DLT, :DLTE, :DELETE]           => 0x2E,
      :ZERO  => 0x30,
      :ONE   => 0x31,
      :TWO   => 0x32,
      :THREE => 0x33,
      :FOUR  => 0x34,
      :FIVE  => 0x35,
      :SIX   => 0x36,
      :SEVEN => 0x37,
      :EIGHT => 0x38,
      :NINE  => 0x39,
      :A => 0x41,
      :B => 0x42,
      :C => 0x43,
      :D => 0x44,
      :E => 0x45,
      :F => 0x46,
      :G => 0x47,
      :H => 0x48,
      :I => 0x49,
      :J => 0x4A,
      :K => 0x4B,
      :L => 0x4C,
      :M => 0x4D,
      :N => 0x4E,
      :O => 0x4F,
      :P => 0x50,
      :Q => 0x51,
      :R => 0x52,
      :S => 0x53,
      :T => 0x54,
      :U => 0x55,
      :V => 0x56,
      :W => 0x57,
      :X => 0x58,
      :Y => 0x59,
      :Z => 0x5A,
      [:LWIN, :LWINDOWS] => 0x5B,
      [:RWIN, :RWINDOWS] => 0x5C,
      [:WIN, :WINDOWS]   => [:LWIN, :RWIN],
      [:NUMPAD0, :NUM0, :N0] => 0x60,
      [:NUMPAD1, :NUM1, :N1] => 0x61,
      [:NUMPAD2, :NUM2, :N2] => 0x62,
      [:NUMPAD3, :NUM3, :N3] => 0x63,
      [:NUMPAD4, :NUM4, :N4] => 0x64,
      [:NUMPAD5, :NUM5, :N5] => 0x65,
      [:NUMPAD6, :NUM6, :N6] => 0x66,
      [:NUMPAD7, :NUM7, :N7] => 0x67,
      [:NUMPAD8, :NUM8, :N8] => 0x68,
      [:NUMPAD9, :NUM9, :N9] => 0x69,
      [:MULT, :MULTIPLY, :MULTIPLICATION]                     => 0x6A,
      [:ADD, :ADDITION]                                       => 0x6B,
      [:SUBTR, :SUBTRACT, :SUBTRACTION]                       => 0x6D,
      [:DCML, :DECIMAL, :DECIMALPNT, :DCMLPNT, :DECIMALPOINT] => 0x6E,
      [:DIV, :DIVIDE, :DIVISION]                              => 0x6F,
      :F1  => 0x70,
      :F2  => 0x71,
      :F3  => 0x72,
      :F4  => 0x73,
      :F5  => 0x74,
      :F6  => 0x75,
      :F7  => 0x76,
      :F8  => 0x77,
      :F9  => 0x78,
      :F10 => 0x79,
      :F11 => 0x7A,
      :F12 => 0x7B,
      [:NMLK, :NUMLCK, :NUMLOCK]            => 0x90,
      [:SCRLLK, :SCROLLCK, :SCROLLLOCK]     => 0x91,
      [:SMICLN, :SEMICOLON]                 => 0xBA,
      [:EQL, :EQLSGN, :EQLSIGN, :EQUALSIGN] => 0xBB,
      [:CMA, :COMMA]                        => 0xBC,
      :DASH                                 => 0xBD,
      [:PRD, :PERIOD]                       => 0xBE,
      [:FRWDSLASH, :FORWARDSLASH, :SLASH]   => 0xBF,
      [:GRVACNT, :GRAVEACCENT]              => 0xC0,
      [:OPNBRKT, :OPENBRKT, :OPENBRACKET]   => 0xDB,
      [:BKSLASH, :BACKSLASH]                => 0xDC,
      [:CLSBRKT, :CLOSEBRKT, :CLOSEBRACKET] => 0xDD,
      [:QTE, :QUOTE]                        => 0xDE
  }

  def self.method_missing(*args)
    if SHORTCUTS[args[0]]
      return MInput.trigger?(*SHORTCUTS[args[0]])
    else
      super *args
    end
  end

  # Returns all keycodes based on an array of symbols/decimals
  # e.g. MInput.keycodes(:PERIOD, :ENTER) #=> [0xBE, 0x0D]
  def self.keycodes(*keys)
    keycodes = []
    for key in keys
      next unless key
      if key.is_a?(Numeric)
        keycodes << key unless keycodes.include?(key)
        next
      end
      valid = false
      STD.keys.each do |e|
        if e == key || e.is_a?(Array) && e.include?(key)
          if STD[e].is_a?(Array)
            for code in STD[e]
              if code.is_a?(Symbol)
                code = MInput.keycodes(code)
              else
                code = [code]
              end
              for c in code
                keycodes << c unless keycodes.include?(c)
              end
            end
            valid = true
          else
            code = MInput.keycodes(code)[0]
            keycodes << STD[e] unless keycodes.include?(STD[e])
            valid = true
          end
        end
      end
      raise MInputError, "Invalid key (#{key.inspect})" unless valid
    end
    return keycodes
  end

  # Returns true once on the first call
  def self.trigger?(*keys)
    codes = MInput.keycodes(*keys)
    if MInput.press?(*codes)
      ret = @@TriggerCalls[codes].nil?
      @@TriggerCalls[codes] = true
      return ret
    else
      return false
    end
  end

  # Returns whether or not the button is currently down/being pressed
  def self.press?(*keys)
    keycodes = MInput.keycodes(*keys)
    keycodes.any? { |e| Input.pressex?(e) }
  end

  # Returns true once, waits 'DefaultWaitTimeForInterval' frames, then
  # returns true after every 'interval' frames
  def self.repeat?(*keys)
    if keys[-1].is_a?(Numeric)
      interval = keys[-1]
      keys = keys[0..-2]
    end
    interval ||= 2
    codes = MInput.keycodes(*keys)
    if MInput.press?(*codes)
      if @@RepeatCalls[codes].nil?
        @@RepeatCalls[codes] = DefaultWaitTimeForInteval
      elsif @@RepeatCalls[codes] == 0
        @@RepeatCalls[codes] = interval
        return true
      else
        return false
      end
    else
      @@RepeatCalls.delete(codes) if @@RepeatCalls[codes]
      return false
    end
  end
end

# Makes Input.update also call MInput.update
module Input
  class << self
    alias minput_update update
  end
  
  def self.update
    minput_update
    MInput.update
  end
end

MInput.update # Updates once to initialize all variables