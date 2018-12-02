extends Spatial

const CHARACTER_SCENE = preload('res://scenes/character/generic.tscn')

export(String, 'LABEL_FARMER', 'LABEL_GEOLOGUE', 'LABEL_ENGINEER', 'LABEL_MECANO') var character_type
var used = false

func spawn_character():
  var character = null

  if not used:
    used = true
    character = CHARACTER_SCENE.instance()
    character.set_type(character_type)

  return character

func is_used():
  return used
