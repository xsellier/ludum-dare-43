extends 'res://scripts/world/generic.gd'

const MINE_SCENE = preload('res://scenes/tileset/mine.tscn')
const TRASH_SCENE = preload('res://scenes/tileset/trash.tscn')

onready var mine_spots = interactive_node.get_node('mine/spot')

func generate_world():
  restore()

  _generate_mines()
  _generate_trash()

func _generate_mines():
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

func character_pick_zinc(player, zinc):
  # TODO add zinc to game stats
  zinc.queue_free()

func character_pick_trash(player, trash):
  # TODO add trash to game stats
  trash.queue_free()