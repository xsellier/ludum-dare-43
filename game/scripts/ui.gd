extends CanvasLayer

onready var metal_node = get_node('container/spaceship/margin/container/metal/value')
onready var engine_node = get_node('container/spaceship/margin/container/engine/value')

func add_resource(resource):
  if resource.type == 'metal':
    metal_node.value += resource.value
  else:
    engine_node.value += resource.value
