module MessageConfig
  FONT_NAME        = "Power Green" #"FusionPixelMonoPatched"
  SMALL_FONT_NAME  = "Power Green Small"
  NARROW_FONT_NAME = "Power Green Narrow"

  SHADOW_TEXT_Y_OFFSET = 0
  FONT_Y_OFFSET        = 0
  SMALL_FONT_Y_OFFSET  = 0
  NARROW_FONT_Y_OFFSET = 0
end

def getLineBrokenText_chinese(bitmap, value, width, dims)
  x = 0
  y = 0
  textheight = 0
  ret = []
  if dims
    dims[0] = 0
    dims[1] = 0
  end
  return ret if !bitmap || bitmap.disposed? || width <= 0
  textmsg = value.delete(" ").clone
  ret.push(["", 0, 0, 0, bitmap.text_size("国").height, 0, 0, 0, 0])
  textmsg.each_line do |line|
    length = line.scan(/./m).length
    line.each_char do |char|
      textSize = bitmap.text_size(char)
      textwidth = textSize.width
      if x > 0 && x + textwidth >= width - 2
        ret.push(["", x, y, 0, textheight, 0, 0, 0, 0])
        x = 0
        y += textheight.zero? ? bitmap.text_size("国").height : textheight
        textheight = 0
      end
      textheight = [textheight, textSize.height].max
      ret.push([char, x, y, textwidth, textheight, 0, 0, 0, length])
      x += textwidth
      dims[0] = x if dims && dims[0] < x
    end
    y += textheight if y > 0
  end
  dims[1] = y + textheight if dims
  ret
end

def getLineBrokenChunks_chinese(bitmap, value, width, dims, plain = false)
  x = 0
  y = 0
  ret = []
  if dims
    dims[0] = 0
    dims[1] = 0
  end
  return ret if !bitmap || bitmap.disposed? || width <= 0
  textmsg = value.clone
  color = Font.default_color
  textmsg.each_char do |ch|
    if ch == "\n"
      x = 0
      y += 32
      next
    end
    textSize = bitmap.text_size(ch)
    textwidth = textSize.width
    if x > 0 && x + textwidth > width && ch !~ /[[:punct:]]/
      x = 0
      y += 32
    end
    ret.push([ch, x, y, textwidth, 32, color])
    x += textwidth
    dims[0] = x if dims && dims[0] < x
  end
  dims[1] = y + 32 if dims
  ret
end

def is_chinese_char?(char)
  char.ord >= 0x4e00 && char.ord <= 0x9fa5
end

def modify_textchunks(textchunks)
  textchunks.each do |chunk|
    chunk.gsub!(/&lt;/, "<")
    chunk.gsub!(/&gt;/, ">")
    chunk.gsub!(/&apos;/, "'")
    chunk.gsub!(/&quot;/, "\"")
    chunk.gsub!(/&amp;/, "&")
    chunk.gsub!(/&m;/, "♂")
    chunk.gsub!(/&f;/, "♀")
  end
  textchunks
end

def _MAPINTL(mapid, *arg)
  string = MessageTypes.getFromMapHash(mapid, arg[0])
  string = string.clone
  (1...arg.length).each do |i|
    string.gsub!(/\{#{i}\}/, arg[i].to_s) 
  end
  string = string.gsub(/([\p{Han}\p{P}])\s+([\p{Han}\p{P}])/, '\1\2') if is_chinese?
  return string
end