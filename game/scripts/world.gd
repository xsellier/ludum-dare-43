extends Spatial

var height = 0
var lamp_moving = false
var time = 0
var size = 64

onready var vp = get_node('vp')
onready var noise = get_node('vp/noise')

var color = Color(0.5, 1, 0.83, 1)

func _ready():
	
	var t = ImageTexture.new()
	t.create(size, size, 0, 0)
	noise.texture = t
	vp.size = Vector2(size, size)
	noise.get_material().set_shader_param('scale', 4.0)
	noise.get_material().set_shader_param('offset', Vector2(5, 5))
	
	# Configure
	$terrain.get_surface_material(0).set_shader_param("tex", t.storage)
	$terrain.get_surface_material(0).set_shader_param("height_range", 0)
	$terrain.get_surface_material(0).set_shader_param("color", color)

func _process(delta):
	if lamp_moving:
		time += delta
		$lamp.translation.x = 20 * sin(time);

func _input(event):
	# increase terrain height
	if event.is_action_pressed("ui_up") and not event.is_echo():
		height += 1
		$terrain.get_surface_material(0).set_shader_param("height_range", height)
	# decrease terrain height
	elif event.is_action_pressed("ui_down") and not event.is_echo():
		height -= 1
		$terrain.get_surface_material(0).set_shader_param("height_range", height)