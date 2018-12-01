extends Spatial

export(int, 2, 5) var Y_AXIS_MAX_DECAL = 3

onready var camera = get_node('camera')
onready var mouse_previous_position = get_viewport().get_mouse_position()

onready var y_axis_inc = 0

func _process(delta):
  var move = Vector3(0, 0, 0)
  var current_mouse_position = get_viewport().get_mouse_position()

  if Input.is_action_pressed('ui_right'):
    print('Right pressed')
    move += Vector3(1.0, 0, 0)

  if Input.is_action_pressed('ui_left'):
    print('Left pressed')
    move += Vector3(-1.0, 0, 0)

  if Input.is_action_pressed('ui_up'):
    print('Up pressed')
    move += Vector3(0.0, 0, -1.0)

  if Input.is_action_pressed('ui_down'):
    print('Up pressed')
    move += Vector3(0.0, 0, 1.0)

  if Input.is_action_pressed('ui_rotate'):
    var angle = (current_mouse_position - mouse_previous_position) * delta / 10.0

    # camera.rotate_z(angle.y)
    rotate_y(angle.x)

  if Input.is_action_just_released('ui_zoom_in') and y_axis_inc < Y_AXIS_MAX_DECAL:
    y_axis_inc += 1
    translate(Vector3(0.0, -2.0, 0.0))

  if Input.is_action_just_released('ui_zoom_out')and y_axis_inc > -Y_AXIS_MAX_DECAL:
    y_axis_inc -= 1
    translate(Vector3(0.0, 2.0, 0.0))

  translate(move * delta * 25.0)
  mouse_previous_position = current_mouse_position
  
  
  
