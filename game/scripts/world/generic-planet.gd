extends 'res://scripts/world/generic.gd'

const MINE_SCENE = preload('res://scenes/tileset/mine.tscn')
const TRASH_SCENE = preload('res://scenes/tileset/trash.tscn')
const SCALE_THRESHOLD = [0.8, 3.0]

onready var mine_spots = interactive_node.get_node('mine/spot')

func generate_world(game_node):
  current_game_node = game_node
  restore()

  _generate_mines()
  _generate_trash()
  gate_node.connect('character_entered', self, 'character_entered', [], CONNECT_DEFERRED)

func _generate_mines():
  var mines_to_generate = [] + mine_spots.get_children()
  var mine_amount_remove = number_util.random(3, mines_to_generate.size() - 3)

  for index in range(0, mine_amount_remove):
    var mine_to_remove = number_util.random(0, mines_to_generate.size())

    mines_to_generate.remove(mine_to_remove)

  for mine_spot in mines_to_generate:
    var mine_scene_instance = MINE_SCENE.instance()
    var scale_value = number_util.randomf(SCALE_THRESHOLD[0], SCALE_THRESHOLD[1])

    interactive_node.get_node('mine').add_child(mine_scene_instance)

    mine_scene_instance.scale_object_local(Vector3(scale_value, scale_value, scale_value))
    mine_scene_instance.rotate_y(number_util.randomf(0, 1))
    mine_scene_instance.translation = mine_spot.translation

func _generate_trash():
  var trash_spots = interactive_node.get_node('trash/spot')
  var trashs_to_generate = [] + trash_spots.get_children()
  var trash_amount_remove = number_util.random(5, trashs_to_generate.size() - 3)

  for index in range(0, trash_amount_remove):
    var trash_to_remove = number_util.random(0, trashs_to_generate.size())

    trashs_to_generate.remove(trash_to_remove)

  for trash_spot in trashs_to_generate:
    var trash_scene_instance = TRASH_SCENE.instance()

    interactive_node.get_node('trash').add_child(trash_scene_instance)
    trash_scene_instance.translation = trash_spot.translation
