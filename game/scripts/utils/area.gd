extends Area

var node_ready = false
var monitoring_status = false
var monitorable_status = false

func _ready():
  node_ready = true
  monitoring_status = monitoring
  monitorable_status = monitorable

func _enter_tree():
  if node_ready:
    monitoring = monitoring_status
    monitorable = monitorable_status

func _exit_tree():
  monitoring = false
  monitorable = false
