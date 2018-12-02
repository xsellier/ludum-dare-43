extends Spatial

const DEFAULT_INTERVAL = 5.0
const CHARACTER_SCENE = preload('res://scenes/character/generic.tscn')

var current_character = null

signal spawn_character(character)

func spawn_character():
  return CHARACTER_SCENE.instance()

func get_character():
  return current_character
