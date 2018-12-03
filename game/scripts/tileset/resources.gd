extends Spatial

const number_util = preload('res://scripts/utils/number.gd')

export(String, 'metal', 'trash') var resource_type

onready var animation_node = get_node('animation/animation')

func get_resource():
  return {
    type = resource_type,
    value = number_util.random(30, 45)
  }

func grab_object():
  animation_node.play('grab')
  