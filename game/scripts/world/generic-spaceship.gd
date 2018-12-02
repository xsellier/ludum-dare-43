extends 'res://scripts/world/generic.gd'

const CHARACTER_SCENE = preload('res://scenes/character/generic.tscn')

func _ready():
  spawner = interactive_node.get_node('spawner')

func generate_world():
  var character = CHARACTER_SCENE.instance()

  set_character(character)
