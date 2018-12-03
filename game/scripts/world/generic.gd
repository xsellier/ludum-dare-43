extends Navigation

const VALUES = {
  oxygen = -4.0,
  food = -2.0
}

# Member variables
const number_util = preload('res://scripts/utils/number.gd')
const node_util = preload('res://scripts/utils/node.gd')

onready var interactive_node = get_node('interactif')
onready var characters_node = get_node('characters')
onready var gate_node = interactive_node.get_node('gate')
onready var exit_node = interactive_node.get_node('exit')

var current_game_node

signal character_gate_entered()

func character_entered():
  emit_signal('character_gate_entered')

func restore():
  var character = current_game_node.previous_world._get_character()

  node_util.reparent(character, characters_node)
  character.translation = get_closest_point(exit_node.translation)
  character.set_idle()
  character.set_health_decr(VALUES)

func _get_character():
  var characters = characters_node.get_children()
  var character_index = characters.size() - 1
  var character = null

  if characters.size() > 0 and not characters[character_index].is_dead():
    character = characters[character_index]

  return character

func _input(event):
  var character = _get_character()

  # Guardian clause
  if character == null:
    return

  if (event.is_class('InputEventMouseButton') and event.button_index == BUTTON_LEFT and event.pressed):
    var from = get_node('camera/camera').project_ray_origin(event.position)
    var to = from + get_node('camera/camera').project_ray_normal(event.position)*100
    var begin = get_closest_point(character.get_translation())
    var end = get_closest_point_to_segment(from, to)

    character.update_path(get_simple_path(begin, end, true))

func generate_world(game_node):
  pass
