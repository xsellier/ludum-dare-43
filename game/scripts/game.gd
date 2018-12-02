extends Node

const node_util = preload('res://scripts/utils/node.gd')
const GATE_NODES = 'world_gate'

const WORLDS = [{
  scene = preload('res://scenes/world/generic-spaceship.tscn'),
  instance = null,
  world = preload('res://world/spaceship.tres'),
  generated = false
}, {
  scene = preload('res://scenes/world/generic-planet.tscn'),  
  instance = null,
  world = preload('res://world/planet.tres'),
  generated = false
}]

onready var world_index = 0
onready var environment_node = get_node('WorldEnvironment')
onready var world_parent = get_node('world')
onready var timer_node = get_node('loader')
onready var loading_panel = get_node('loading/center')
onready var current_item = get_world_scene()

var gate_nodes = null

func _ready():
  timer_node.connect('timeout', self, 'attach_new_world')
  attach_new_world()

func attach_new_world():
  # Update environment
  loading_panel.hide()
  environment_node.environment = WORLDS[world_index].world

  world_parent.add_child(current_item)
  gate_nodes = get_tree().get_nodes_in_group(GATE_NODES)

  for gate_node in gate_nodes:
    gate_node.connect('character_entered', self, 'change_world', [], CONNECT_ONESHOT)

  if WORLDS[world_index].generated:
    current_item.restore()
  else:
    # Flag world as generated
    WORLDS[world_index].generated = true

    current_item.generate_world()

func change_world(character):
  world_index = (world_index + 1) % WORLDS.size()
  var next_item = get_world_scene()

  node_util.reparent(character, next_item)
  character.set_name('character')

  # Clean old world
  current_item = next_item

  node_util.remove_children(world_parent)
  loading_panel.show()
  timer_node.start()

func get_world_scene():
  if not WORLDS[world_index].generated:
    WORLDS[world_index].instance = WORLDS[world_index].scene.instance()

  return WORLDS[world_index].instance