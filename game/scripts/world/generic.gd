extends Navigation

# Member variables
const SPEED = 4.0
const number_util = preload('res://scripts/utils/number.gd')
const node_util = preload('res://scripts/utils/node.gd')

onready var interactive_node = get_node('interactif')
onready var gate_node = interactive_node.get_node('gate')
onready var exit_node = interactive_node.get_node('exit')

var begin = Vector3()
var end = Vector3()
var m = SpatialMaterial.new()
var path = []
var draw_path = OS.is_debug_build()
var current_character = null

signal character_gate_entered(character)

func _ready():
  m.flags_unshaded = true
  m.flags_use_point_size = true
  m.albedo_color = Color(1.0, 1.0, 1.0, 1.0)

func character_entered(character):
  emit_signal('character_gate_entered', character)

func restore():
  current_character = get_node('character')
  current_character.translation = get_closest_point(exit_node.translation)

  set_process(false)

func _get_character():
  var character = null

  if current_character != null and not current_character.is_dead():
    character = current_character

  return character

func _process(delta):
  var character = _get_character()

  # Guardian clause
  if character == null:
    return

  if (path.size() > 1):
    var to_walk = delta * SPEED
    var to_watch = Vector3(0, 1, 0)

    while(to_walk > 0 and path.size() >= 2):
      var pfrom = path[path.size() - 1]
      var pto = path[path.size() - 2]
      to_watch = (pto - pfrom).normalized()
      var d = pfrom.distance_to(pto)
      if (d <= to_walk):
        path.remove(path.size() - 1)
        to_walk -= d
      else:
        path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
        to_walk = 0
    
    var atpos = path[path.size() - 1]
    var atdir = to_watch
    atdir.y = 0
    
    var t = Transform()
    t.origin = atpos

    t = t.looking_at(atpos + atdir, Vector3(0, 1, 0))
    character.set_transform(t)
    
    if (path.size() < 2):
      path = []
      set_process(false)
  else:
    set_process(false)


func _update_path():
  var p = get_simple_path(begin, end, true)
  path = Array(p) # Vector3array too complex to use, convert to regular array
  path.invert()
  set_process(true)

  if (draw_path):
    var im = get_node('draw')
    im.set_material_override(m)
    im.clear()
    im.begin(Mesh.PRIMITIVE_POINTS, null)
    im.add_vertex(begin)
    im.add_vertex(end)
    im.end()
    im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
    for x in p:
      im.add_vertex(x)
    im.end()


func _input(event):
  var character = _get_character()

  # Guardian clause
  if character == null:
    return

  if (event.is_class('InputEventMouseButton') and event.button_index == BUTTON_LEFT and event.pressed):
    var from = get_node('camera/camera').project_ray_origin(event.position)
    var to = from + get_node('camera/camera').project_ray_normal(event.position)*100
    
    begin = get_closest_point(character.get_translation())
    end = get_closest_point_to_segment(from, to)

    _update_path()

func generate_world():
  pass
