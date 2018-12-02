extends Spatial

onready var area_node = get_node('door/area')

signal character_entered()

func _ready():
  area_node.connect('area_entered', self, 'area_entered', [], CONNECT_DEFERRED)

func area_entered(object):
  emit_signal('character_entered')
