extends 'res://scripts/world/generic.gd'

onready var spawner_nodes = interactive_node.get_node('spawners')
onready var available_spawners = [] + spawner_nodes.get_children()

func generate_world():
  _spawn_character()

  gate_node.connect('character_entered', self, 'character_entered', [], CONNECT_DEFERRED)

func _spawn_character():
  var spawner_index = number_util.random(0, available_spawners.size())
  var spawner_node = available_spawners[spawner_index]

  available_spawners.remove(spawner_index)

  current_character = spawner_node.spawn_character()
  node_util.reparent(current_character, self)
  current_character.translation = get_closest_point(spawner_node.translation)
  
  set_process(false)
