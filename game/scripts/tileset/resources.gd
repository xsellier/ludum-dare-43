extends Spatial

const number_util = preload('res://scripts/utils/number.gd')

export(String, 'metal', 'trash') var resource_type

func get_resource():
  return {
    type = resource_type,
    value = number_util.random(30, 45)
  }
