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

func _ready():
  timer_node.connect('timeout', self, 'attach_new_world')

  get_world_scene()
  attach_new_world()

func attach_new_world():
  # Update environment
  environment_node.environment = WORLDS[world_index].world

  node_util.reparent(WORLDS[world_index].instance, world_parent)

  if WORLDS[world_index].generated:
    WORLDS[world_index].instance.call_deferred('restore')
  else:
    # Flag world as generated
    WORLDS[world_index].generated = true
    WORLDS[world_index].instance.call_deferred('generate_world')
    WORLDS[world_index].instance.connect('character_gate_entered', self, 'change_world', [], CONNECT_DEFERRED)

  loading_panel.hide()

func change_world(character):
  loading_panel.show()
  world_index = (world_index + 1) % WORLDS.size()

  node_util.remove_children(world_parent)
  node_util.reparent(character, get_world_scene())

  timer_node.start()

func get_world_scene():
  if not WORLDS[world_index].generated:
    WORLDS[world_index].instance = WORLDS[world_index].scene.instance()

  return WORLDS[world_index].instance