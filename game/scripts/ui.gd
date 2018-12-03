extends CanvasLayer

const main_menu_scene = preload('res://scenes/main.tscn')

onready var metal_node = get_node('container/spaceship/margin/container/metal/value')
onready var engine_node = get_node('container/spaceship/margin/container/engine/value')

onready var animation_node = get_node('animation')
onready var label_node = get_node('gameover/center/container/label')
onready var settlers_label = get_node('gameover/center/container/sacrificed')

onready var button_node = get_node('gameover/center/container/continue')

var current_amount_of_settlers = 0
var gameover = false

func _ready():
  button_node.connect('pressed', self, 'main_menu')

func add_resource(resource):
  if resource.type == 'metal':
    metal_node.value += resource.value
  else:
    engine_node.value += resource.value

  if metal_node.value >= 100.0 and engine_node.value >= 100.0:
    label_node.set_text(tr('LABEL_CONGRATULATIONS'))
    _close()

func inc_amount_of_settlers(value = 1):
  current_amount_of_settlers += value

func lose():
  label_node.set_text(tr('LABEL_GAMEOVER'))
  _close()
  
func _close():
  gameover = true
  settlers_label.set_text(tr('LABEL_SETTLER_KILLED') % [current_amount_of_settlers])
  animation_node.play('setup')

func main_menu():
  # Kill current scene
  get_parent().queue_free()
  get_tree().change_scene_to(main_menu_scene)

func is_gameover():
  return gameover