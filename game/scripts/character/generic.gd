extends Spatial

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

onready var character_type = 'LABEL_FARMER'
onready var info_node = get_node('info')
onready var animation_node = get_node('animation')
onready var area_node = get_node('area')

var current_state = CHARACTER_STATE.IDLE
var path = []
var object_to_free = null

func _ready():
  set_process(true)

  animation_node.connect('animation_finished', self, 'set_idle')
  area_node.connect('area_entered', self, 'grab_object', [], CONNECT_DEFERRED)

func grab_object(object):
  object_to_free = object.get_parent().get_parent()
  _update_state(CHARACTER_STATE.GRAB)

func free_object():
  if object_to_free != null:
    object_to_free.queue_free()
    object_to_free = null

func _process(delta):
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
  return false

func _update_gui():
  var camera = get_tree().get_root().get_camera()
  var screen_position = camera.unproject_position(translation)

  info_node.set_position(Vector2(screen_position.x, screen_position.y) + NINE_PATCH_DECAL)

func _update_state(next_state):
  if current_state != next_state:
    current_state = next_state
    print('Playing animation %s' % [current_state.animation])
    _play_animation(current_state.animation)

func set_idle(object = null):
  _update_state(CHARACTER_STATE.IDLE)

func _play_animation(animation_name):
  animation_node.stop(true)
  animation_node.play(animation_name)
