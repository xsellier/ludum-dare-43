extends Spatial

const DECR_INTERVAL = 0.5
const CHARACTER_STATE = {
  WALK = {
    animation = 'walk'
  },
  IDLE = {
    animation = 'idle'
  },
  DIE = {
    animation = 'die'
  },
  GRAB = {
    animation = 'grab'
  }
}

const SPEED = 4.0
const NINE_PATCH_DECAL = Vector2(0.0, -20.0)
const node_util = preload('res://scripts/utils/node.gd')

onready var character_type = 'LABEL_FARMER'
onready var info_node = get_node('info')
onready var animation_node = get_node('animation')
onready var area_node = get_node('area')

# UI
onready var oxygen_value = get_node('info/container/container/oxygen/value')
onready var food_value = get_node('info/container/container/food/value')
onready var ui_animation_node = get_node('info/animation')
onready var ui_node = get_tree().get_nodes_in_group('ui')[0]

var current_state = CHARACTER_STATE.IDLE
var path = []
var object_to_free = null
var delta_acc = 0
var health_decr = null

func _ready():
  set_process(true)

  animation_node.connect('animation_finished', self, 'set_idle')
  area_node.connect('area_entered', self, 'grab_object', [], CONNECT_DEFERRED)

func grab_object(object):
  object_to_free = object.get_parent().get_parent()
  _update_state(CHARACTER_STATE.GRAB)

func set_health_decr(value):
  health_decr = value

func free_object():
  if object_to_free != null:
    ui_node.add_resource(object_to_free.get_resource())
    object_to_free.queue_free()
    object_to_free = null

func _update_health():
  if health_decr != null:
    oxygen_value.value += health_decr.oxygen
    food_value.value += health_decr.food

  if food_value.value <= 0 or oxygen_value.value <= 0:
    set_dead()

func _process(delta):
  delta_acc += delta

  if delta_acc > DECR_INTERVAL:
    delta_acc -= DECR_INTERVAL

    _update_health()
  _update_gui()

  if current_state == CHARACTER_STATE.WALK:
    if path.size() > 1:
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
      set_transform(t)
      
      if (path.size() < 2):
        path = []
        _update_state(CHARACTER_STATE.IDLE)
    else:
      _update_state(CHARACTER_STATE.IDLE)

func update_path(new_path):
  # We don't want to walk while we are grabbing an object
  if current_state == CHARACTER_STATE.IDLE or current_state == CHARACTER_STATE.WALK:
    path = Array(new_path)
    path.invert()

    _update_state(CHARACTER_STATE.WALK)

func set_type(type):
  character_type = type

func is_dead():
  return current_state == CHARACTER_STATE.DIE

func _update_gui():
  var camera = get_tree().get_root().get_camera()
  var screen_position = camera.unproject_position(translation)

  info_node.set_position(Vector2(screen_position.x, screen_position.y) + NINE_PATCH_DECAL)

func _update_state(next_state):
  if current_state == CHARACTER_STATE.DIE:
    # Player is dead
    return

  if current_state != next_state:
    current_state = next_state
    _play_animation(current_state.animation)

    if current_state == CHARACTER_STATE.DIE:
      ui_animation_node.play_backwards('setup')

func set_dead():
  _update_state(CHARACTER_STATE.DIE)

func set_idle(object = null):
  if object != null and current_state == CHARACTER_STATE.DIE:
    var world_node = get_parent().get_parent()
    var game_node = world_node.get_parent().get_parent()

    node_util.reparent(world_node.get_node('dead_characters'), world_node)
    game_node.respawn()
  else:
    _update_state(CHARACTER_STATE.IDLE)

func _play_animation(animation_name):
  animation_node.stop(true)
  animation_node.play(animation_name)
