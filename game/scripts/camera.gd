extends Spatial

onready var camera = get_node('camera')
onready var mouse_previous_position = get_viewport().get_mouse_position()

func _process(delta):
  var move = Vector3(0, 0, 0)
  var current_mouse_position = get_viewport().get_mouse_position()

  if Input.is_action_pressed('ui_right'):
    move += Vector3(1.0, 0, 0)

  if Input.is_action_pressed('ui_left'):
    move += Vector3(-1.0, 0, 0)

  if Input.is_action_pressed('ui_up'):
    move += Vector3(0.0, 0, -1.0)

  if Input.is_action_pressed('ui_down'):
    move += Vector3(0.0, 0, 1.0)

  if Input.is_action_pressed('ui_rotate'):
    var angle = (current_mouse_position - mouse_previous_position) * delta / -10.0

    # camera.rotate_z(angle.y)
    rotate_y(angle.x)

  if Input.is_action_just_released('ui_zoom_in'):
    camera.fov = clamp(camera.fov - 10.0, 10, 80)

  if Input.is_action_just_released('ui_zoom_out'):
    camera.fov = clamp(camera.fov + 10.0, 10, 80)

  translate(move * delta * 25.0)
  mouse_previous_position = current_mouse_position
  
  
  
