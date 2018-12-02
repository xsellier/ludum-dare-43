static func random(min_value, max_value):
  randomize()

  return randi() % int(max_value - min_value) + int(min_value)

static func randomf(min_value, max_value):
  randomize()

  return randf() * float(max_value - min_value) + float(min_value)
