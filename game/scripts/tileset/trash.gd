extends Spatial

const number_util = preload('res://scripts/utils/number.gd')

const SCALE_THRESHOLD = [0.8, 3.0]
const TRASH_LIST = [
  preload('res://scenes/tileset/trash-antenna.tscn'),
  preload('res://scenes/tileset/trash-parabole.tscn'),
  preload('res://scenes/tileset/trash-shield-large.tscn'),
  preload('res://scenes/tileset/trash-shield-small.tscn'),
  preload('res://scenes/tileset/trash-balise.tscn'),
  preload('res://scenes/tileset/trash-small-balise.tscn'),
  preload('res://scenes/tileset/trash-rounded-balise.tscn'),
]

# Pick a random trash
func _ready():
  var trash_scene = TRASH_LIST[number_util.random(0, TRASH_LIST.size() - 1)]
  var trash_instance = trash_scene.instance()
  var scale_value = number_util.randomf(SCALE_THRESHOLD[0], SCALE_THRESHOLD[1])

  trash_instance.scale_object_local(Vector3(scale_value, scale_value, scale_value))
  trash_instance.rotate_y(number_util.randomf(1, 3))
  add_child(trash_instance)
