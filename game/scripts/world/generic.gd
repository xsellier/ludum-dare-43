extends Navigation

# Member variables
const SPEED = 4.0
const number_util = preload('res://scripts/utils/number.gd')
const MINE_SCENE = preload('res://scenes/tileset/mine.tscn')
const TRASH_SCENE = preload('res://scenes/tileset/trash.tscn')

export(bool) var contain_mines = false
export(bool) var contain_trash = false
export(bool) var contain_spawner = false

onready var interactive_node = get_node('interactif')
onready var gate_node = interactive_node.get_node('gate')
onready var exit_node = interactive_node.get_node('exit')
onready var exit_translation = exit_node.translation

var spawner = null
var begin = Vector3()
var end = Vector3()
var m = SpatialMaterial.new()
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
  elif contain_spawner:
    spawner = interactive_node.get_node('spawner')
    spawner.connect('spawn_character', self, 'set_character')

  if contain_mines:
    _generate_mines()
    
  if contain_trash:
    _generate_trash()

func _generate_mines():
  var mine_spots = interactive_node.get_node('mine/spot')
  var mines_to_generate = [] + mine_spots.get_children()
  var mine_amount_remove = number_util.random(2, mines_to_generate.size() - 2)

  for index in range(0, mine_amount_remove):
    var mine_to_remove = number_util.random(0, mines_to_generate.size())

    mines_to_generate.remove(mine_to_remove)

  for mine_spot in mines_to_generate:
    var mine_scene_instance = MINE_SCENE.instance()

    interactive_node.get_node('mine').add_child(mine_scene_instance)

    mine_scene_instance.translation = mine_spot.translation
    mine_scene_instance.connect('character_pick_zinc', self, 'character_pick_zinc')

func _generate_trash():
  var trash_spots = interactive_node.get_node('trash/spot')
  var trashs_to_generate = [] + trash_spots.get_children()
  var trash_amount_remove = number_util.random(4, trashs_to_generate.size() - 3)

  for index in range(0, trash_amount_remove):
    var trash_to_remove = number_util.random(0, trashs_to_generate.size())

    trashs_to_generate.remove(trash_to_remove)

  for trash_spot in trashs_to_generate:
    var trash_scene_instance = TRASH_SCENE.instance()

    interactive_node.get_node('trash').add_child(trash_scene_instance)

    trash_scene_instance.translation = trash_spot.translation
    trash_scene_instance.connect('character_pick_trash', self, 'character_pick_trash')

func character_pick_zinc(player, zinc) :
  # TODO add zinc to game stats
  zinc.queue_free()

func character_pick_trash(player, trash) :
  # TODO add trash to game stats
  trash.queue_free()

func set_character(character_node, use_spawner = true):
  var translation = exit_translation

  if use_spawner:
    add_child(character_node)
    translation = spawner.translation

  current_character = character_node
  current_character.translation = get_closest_point(translation)
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

