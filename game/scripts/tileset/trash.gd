extends Spatial

const number_util = preload('res://scripts/utils/number.gd')

const TRASH_LIST = [
  preload('res://scenes/tileset/trash-antenna.tscn'),
  preload('res://scenes/tileset/trash-parabole.tscn'),
  preload('res://scenes/tileset/trash-shield-large.tscn'),
  preload('res://scenes/tileset/trash-shield-small.tscn'),
]

signal character_pick_trash(characterNode, trashNode)

func _ready():
  # pick a random trash
  var trash_scene = TRASH_LIST[number_util.random(0, TRASH_LIST.size() - 1)]
  var trash_instance = trash_scene.instance()
  add_child(trash_instance)
  trash_instance.get_node('item/area').connect('area_entered', self, 'area_entered')

func area_entered(object):
  emit_signal('character_pick_trash', object.get_parent().get_parent(), self)
