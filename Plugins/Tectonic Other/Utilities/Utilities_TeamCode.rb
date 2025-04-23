require 'stringio'

# Bit protocol shift constants
VERSION_MAJOR_SHIFT = 0
VERSION_MINOR_SHIFT = 5
VERSION_PATCH_SHIFT = 10
VERSION_DEV_SHIFT = 15 # End of header, not repeated - u16
POKEMON_SHIFT = 0
ABILITY_SHIFT = 11
MOVE1_SHIFT = 12
MOVE2_SHIFT = 22 # End of first u32
STYLE_HP_SHIFT = 0
STYLE_ATK_SHIFT = 5
STYLE_DEF_SHIFT = 10
STYLE_SDEF_SHIFT = 15
STYLE_SPEED_SHIFT = 20
LEVEL_SHIFT = 25 # End of second u32
MOVE3_SHIFT = 0
MOVE4_SHIFT = 10
ITEM1_SHIFT = 20
FLAG_HAS_2_ITEM_SHIFT = 28
FLAG_HAS_ITEM1_TYPE_SHIFT = 29
FLAG_HAS_FORM_SHIFT = 30 # End of third u32

# Byte protocol masks
VERSION_MAJOR_MASK = 0b11111 << VERSION_MAJOR_SHIFT
VERSION_MINOR_MASK = 0b11111 << VERSION_MINOR_SHIFT
VERSION_PATCH_MASK = 0b11111 << VERSION_PATCH_SHIFT
VERSION_DEV_MASK = 0b1 << VERSION_DEV_SHIFT
POKEMON_MASK = 0b111_1111_1111 << POKEMON_SHIFT
ABILITY_MASK = 0b1 << ABILITY_SHIFT
MOVE1_MASK = 0b11_1111_1111 << MOVE1_SHIFT
MOVE2_MASK = 0b11_1111_1111 << MOVE2_SHIFT
STYLE_HP_MASK = 0b11111 << STYLE_HP_SHIFT
STYLE_ATK_MASK = 0b11111 << STYLE_ATK_SHIFT
STYLE_DEF_MASK = 0b11111 << STYLE_DEF_SHIFT
STYLE_SDEF_MASK = 0b11111 << STYLE_SDEF_SHIFT
STYLE_SPEED_MASK = 0b11111 << STYLE_SPEED_SHIFT
LEVEL_MASK = 0b1111111 << LEVEL_SHIFT
MOVE3_MASK = 0b11_1111_1111 << MOVE3_SHIFT
MOVE4_MASK = 0b11_1111_1111 << MOVE4_SHIFT
ITEM1_MASK = 0b1111_1111 << ITEM1_SHIFT
FLAG_HAS_2_ITEM_MASK = 0b1 << FLAG_HAS_2_ITEM_SHIFT
FLAG_HAS_ITEM1_TYPE_MASK = 0b1 << FLAG_HAS_ITEM1_TYPE_SHIFT
FLAG_HAS_FORM_MASK = 0b1 << FLAG_HAS_FORM_SHIFT

MIN_BYTES_PER_POKEMON = 12
MAX_BYTES_PER_POKEMON = 16

def get_held_item_index(symbol)
  symbols = GameData::Item.keys.filter{ |key| !key.is_a?(Numeric) && key.is_a?(Symbol) && GameData::Item.get(key).pocket == 5 }
  index = symbols.find_index(symbol)
  if index.nil? 
    return -1 
  end
  return index
end

def get_type_index(symbol)
  symbols = GameData::Type.keys.filter{ |key| !key.is_a?(Numeric) && key.is_a?(Symbol) }
  index = symbols.find_index(symbol)
  if index.nil? 
    return -1 
  end
  return index
end

def pokemon_to_indices(mon)
  species_data = GameData::Species.get(mon.species)
  species = species_data.id_number # Pokedex order corresponds to index order
  ability = mon.ability_index
  moves = mon.moves.map { |move| species_data.learnable_moves.find_index(move.id) }
  moves.fill(-1, moves.length..3)
  sp = mon.ev
  level = mon.level
  items = mon.items.map { |item| get_held_item_index(item) }
  items.fill(-1, items.length..1)
  itemtype = get_type_index(mon.itemTypeChosen)
  form = mon.form

  indices = []

  # First u32: Pokemon, ability, move1, move2
  indices.push(species)
  indices.push(ability)
  indices.push(moves[0])
  indices.push(moves[1])

  # Second u32: Style points and level
  indices.push(sp[:HP])
  indices.push(sp[:ATTACK]) # same as spatk
  indices.push(sp[:DEFENSE])
  indices.push(sp[:SPECIAL_DEFENSE])
  indices.push(sp[:SPEED])
  indices.push(level)

  # Third u32: Move3, move4, item1, and flags
  indices.push(moves[2])
  indices.push(moves[3])
  indices.push(items[0])
  indices.push(items[1]) # if no second item, will be -1
  
  indices.push(itemtype)
  indices.push(form)

  return indices
end

def encode_chunk(buffer, indices)
  first_u32 = 0
  second_u32 = 0
  third_u32 = 0

  # First u32: Pokemon, ability, move1, move2
  first_u32 |= (indices[0] << POKEMON_SHIFT) & POKEMON_MASK
  first_u32 |= (indices[1] << ABILITY_SHIFT) & ABILITY_MASK
  first_u32 |= (indices[2] << MOVE1_SHIFT) & MOVE1_MASK
  first_u32 |= (indices[3] << MOVE2_SHIFT) & MOVE2_MASK

  buffer.write([first_u32].pack('N'))

  # Second u32: Style points and level
  second_u32 |= (indices[4] << STYLE_HP_SHIFT) & STYLE_HP_MASK
  second_u32 |= (indices[5] << STYLE_ATK_SHIFT) & STYLE_ATK_MASK
  second_u32 |= (indices[6] << STYLE_DEF_SHIFT) & STYLE_DEF_MASK
  second_u32 |= (indices[7] << STYLE_SDEF_SHIFT) & STYLE_SDEF_MASK
  second_u32 |= (indices[8] << STYLE_SPEED_SHIFT) & STYLE_SPEED_MASK
  second_u32 |= (indices[9] << LEVEL_SHIFT) & LEVEL_MASK
  
  buffer.write([second_u32].pack('N'))

  # Check for optional data
  has_second_item = indices[13] > -1
  has_item_type = true
  has_form_data = indices[15] > 0

  # Third u32: Move3, move4, item1, and flags
  third_u32 |= (indices[10] << MOVE3_SHIFT) & MOVE3_MASK
  third_u32 |= (indices[11] << MOVE4_SHIFT) & MOVE4_MASK
  third_u32 |= (indices[12] << ITEM1_SHIFT) & ITEM1_MASK
  # TODO: Include optional data
  third_u32 |= (has_second_item ? 1 : 0) << FLAG_HAS_2_ITEM_SHIFT
  third_u32 |= (has_item_type ? 1 : 0) << FLAG_HAS_ITEM1_TYPE_SHIFT
  third_u32 |= (has_form_data ? 1 : 0) << FLAG_HAS_FORM_SHIFT
  
  buffer.write([third_u32].pack('N'))

  if has_second_item
    buffer.write([indices[13]].pack('C'))
  end

  if has_item_type
    buffer.write([indices[14]].pack('C'))
  end

  if has_form_data
    buffer.write([indices[15]].pack('C'))
  end
end

def encode_team(party)
  # Create a string buffer to write binary data
  buffer = StringIO.new
  
  # Process version information
  version_split = Settings::GAME_VERSION.split(".")
  version_u16 = Settings::DEV_VERSION ? VERSION_DEV_MASK : 0
  version_u16 |= (version_split[0].to_i & 0x1f) << VERSION_MAJOR_SHIFT
  version_u16 |= (version_split[1].to_i & 0x1f) << VERSION_MINOR_SHIFT
  version_u16 |= (version_split[2].to_i & 0x1f) << VERSION_PATCH_SHIFT
  
  # Write version to buffer
  buffer.write([version_u16].pack('n'))
  
  # Encode each Pokémon in the party
  party.each do |indices|
    encode_chunk(buffer, indices)
  end
  
  # Convert to base64
  [buffer.string].pack('m0')
end