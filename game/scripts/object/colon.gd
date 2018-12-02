extends MeshInstance

var colors = {
'colon': Color(0.533, 0.522, 0.282),
'geologue' : Color(0.427, 0.227, 0.137),
'ingenieur' : Color(0.208, 0.247, 0.545),
'mecano' : Color(0.498, 0.498, 0.498),
'agriculteur' : Color(0.251, 0.6, 0.239)
}

func _ready():
	randomize()
	var material = SpatialMaterial.new()
	material.albedo_color = colors[colors.keys()[randi()%colors.size()]]
	self.set_surface_material(3, material)