extends Spatial

const number_util = preload('res://scripts/utils/number.gd')

const TRASH_LIST = [
  preload('res://scenes/tileset/trash-antenna.tscn'),
  preload('res://scenes/tileset/trash-parabole.tscn'),
  preload('res://scenes/tileset/trash-shield-large.tscn'),
  preload('res://scenes/tileset/trash-shield-small.tscn'),
]

# Pick a random trash
onready var trash_scene = TRASH_LIST[number_util.random(0, TRASH_LIST.size() - 1)]
onready var trash_instance = trash_scene.instance()

func _ready():
  add_child(trash_instance)
