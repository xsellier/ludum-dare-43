extends Node

const node_util = preload('res://scripts/utils/node.gd')

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

var previous_world = null

func _ready():
  timer_node.connect('timeout', self, 'attach_new_world')

  previous_world = get_world_scene()
  attach_new_world()

func attach_new_world():
  # Update environment
  environment_node.environment = WORLDS[world_index].world

  node_util.reparent(get_world_scene(), world_parent)

  if WORLDS[world_index].generated:
    get_world_scene().call_deferred('restore')
  else:
    # Flag world as generated
    WORLDS[world_index].generated = true
    get_world_scene().call_deferred('generate_world', self)
    get_world_scene().connect('character_gate_entered', self, 'change_world', [], CONNECT_DEFERRED)

  loading_panel.hide()

func change_world():
  previous_world = get_world_scene()
  loading_panel.show()
  world_index = (world_index + 1) % WORLDS.size()

  node_util.remove_children(world_parent)
  timer_node.start()

func get_world_scene():
  if not WORLDS[world_index].generated:
    WORLDS[world_index].instance = WORLDS[world_index].scene.instance()

  return WORLDS[world_index].instance
