extends Spatial

onready var area_node = get_node('filon-zinc/area')

signal character_pick_zinc(characterNode, zincNode)

func _ready():
  area_node.connect('area_entered', self, 'area_entered', [], CONNECT_DEFERRED)

func area_entered(object):
  emit_signal('character_pick_zinc', object.get_parent(), self)
