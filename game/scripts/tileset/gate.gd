extends Spatial

onready var area_node = get_node('area')

signal character_entered(character)

func connect_signals():
  area_node.connect('area_entered', self, 'area_entered')

func area_entered(object):
  emit_signal('character_entered', object.get_parent().get_parent())
