extends 'res://scripts/world/generic.gd'

const VALUES = {
  oxygen = 3.0,
  food = -1.0
}

onready var spawner_nodes = interactive_node.get_node('spawners')
onready var available_spawners = [] + spawner_nodes.get_children()

func generate_world(game_node):
  current_game_node = game_node
  _spawn_character()

  gate_node.connect('character_entered', self, 'character_entered', [], CONNECT_DEFERRED)

func _spawn_character():
  var available_spawner_amount = available_spawners.size()
  var ui_node = get_parent().get_parent().get_node('ui')

  ui_node.inc_amount_of_settlers()

  if available_spawner_amount <= 0:
    ui_node.lose()

    set_process(false)
    return

  var spawner_index = number_util.random(0, available_spawner_amount)
  var spawner_node = available_spawners[spawner_index]

  available_spawners.remove(spawner_index)

  node_util.reparent(spawner_node.spawn_character(), characters_node)
  _get_character().translation = get_closest_point(spawner_node.translation)
  
  set_process(false)
