extends Spatial

const NINE_PATCH_DECAL = Vector2(0.0, -20.0)

onready var info_node = get_node('info')

func is_dead():
  return false

func _process(delta):
  var camera = get_tree().get_root().get_camera()
  var screen_position = camera.unproject_position(translation)

  info_node.set_position(Vector2(screen_position.x, screen_position.y) + NINE_PATCH_DECAL)
