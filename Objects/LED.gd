extends Spatial

func _ready():
	$Blue.get_active_material(0).emission_enabled = false
	$Red.get_active_material(0).emission_enabled = false
	$Green.get_active_material(0).emission_enabled = false

func set_light(led : String, value: bool) -> void:
	get_node(led).get_active_material(0).emission_enabled = value
	get_node(led).get_node("OmniLight").light_energy = 1.0 if value else 0.0
