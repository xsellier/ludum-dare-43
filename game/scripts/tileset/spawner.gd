extends Spatial

const DEFAULT_INTERVAL = 5.0
const CHARACTER_SCENE = preload('res://scenes/character/generic.tscn')

var current_character = null
var delta_acc = DEFAULT_INTERVAL

signal spawn_character(character)

func _process(delta):
  delta_acc += delta

  if delta_acc > DEFAULT_INTERVAL:
    delta_acc -= DEFAULT_INTERVAL

    if current_character == null or current_character.is_dead():
      current_character = CHARACTER_SCENE.instance()

      emit_signal('spawn_character', current_character)

func get_character():
  return current_character
