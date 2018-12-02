extends Node

const node_util = preload('res://scripts/utils/node.gd')
const GATE_NODES = 'world_gate'

const WORLDS = [{
  scene = preload('res://scenes/world/generic-spaceship.tscn'),  
  world = preload('res://world/spaceship.tres')
}, {
  scene = preload('res://scenes/world/generic-planet.tscn'),  
  world = preload('res://world/planet.tres')
}]

onready var world_index = 0
onready var current_item = WORLDS[world_index].scene.instance()
onready var environment_node = get_node('WorldEnvironment')
onready var world_parent = get_node('world')

var gate_nodes = null

func _ready():
  attach_new_world()

func attach_new_world():
  # Update environment
  environment_node.environment = WORLDS[world_index].world

  world_parent.add_child(current_item)
  gate_nodes = get_tree().get_nodes_in_group(GATE_NODES)

  for gate_node in gate_nodes:
    gate_node.connect('character_entered', self, 'change_world', [], CONNECT_ONESHOT)


func change_world(character):
  world_index = (world_index + 1) % WORLDS.size()
  var next_item = WORLDS[world_index].scene.instance()

  node_util.reparent(character, next_item)
  character.set_name('character')

  # Clean old world
  current_item = next_item

  node_util.remove_children(world_parent)
  call_deferred('attach_new_world')
