static func get_child_by_name(node, name):
  return node.get_node(name)

static func remove_children(node):
  for child in node.get_children():
    remove_child_by_node(node, child)

static func remove_child_by_node(node, child):
  if child != null and weakref(child).get_ref():
    node.remove_child(child)

static func reparent(child, new_parent):
  var parent = child.get_parent()

  if parent != null:
    parent.remove_child(child)

  new_parent.add_child(child)
  child.set_owner(new_parent)
