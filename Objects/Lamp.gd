extends MeshInstance

func _ready():
	$Light/Cable.get_active_material(0).emission = $Light.light_color
