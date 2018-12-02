
extends Navigation

# Member variables
const SPEED = 4.0

var spawner = null
var begin = Vector3()
var end = Vector3()
var m = SpatialMaterial.new()

onready var gate_node = get_node('interactif/gate')
var mine = preload("res://scenes/tileset/mine.tscn")

var path = []
var draw_path = OS.is_debug_build()
var current_character = null

func _ready():
  m.flags_unshaded = true
  m.flags_use_point_size = true
  m.albedo_color = Color(1.0, 1.0, 1.0, 1.0)

  set_process_input(true)

  if has_node('character'):
    set_character(get_node('character'), false)
  elif has_node('interactif/spawner'):
    spawner = get_node('interactif/spawner')
    spawner.connect('spawn_character', self, 'set_character')

    # generate mines
  if has_node('interactif/mine/spot'):
    var allMinesSpot = get_node('interactif/mine/spot')
    for spot in allMinesSpot.get_children():
      if randi() % 20 > 12:
        var node = mine.instance()
        get_node('interactif/mine').add_child(node)
        node.set_transform(spot.get_transform())
        node.connect('character_pick_zinc', self, 'character_pick_zinc')

func character_pick_zinc(player, zinc) :
  print("TODO add zinc to game stats")
  zinc.queue_free()

func set_character(character_node, use_spawner = true):
  var position = get_node('exit').translation

  if use_spawner:
    add_child(character_node)
    position = spawner.translation

  current_character = character_node
  current_character.translation = get_closest_point(position)
  gate_node.connect_signals()

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
    var im = get_node("draw")
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

  if (event.is_class("InputEventMouseButton") and event.button_index == BUTTON_LEFT and event.pressed):
    var from = get_node("camera/camera").project_ray_origin(event.position)
    var to = from + get_node("camera/camera").project_ray_normal(event.position)*100
    
    begin = get_closest_point(character.get_translation())
    end = get_closest_point_to_segment(from, to)

    _update_path()

