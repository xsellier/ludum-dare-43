extends Control

onready var newgame_button = get_node('container/main/menu/newgame')
onready var exit_button = get_node('container/main/menu/exit')

func _ready():
  exit_button.connect('pressed', self, 'exit', [], CONNECT_ONESHOT)
  newgame_button.connect('pressed', self, 'newgame')

func newgame():
  get_tree().change_scene_to(load('res://scenes/game.tscn'))

func exit():
  get_tree().quit()
