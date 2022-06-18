extends Spatial

export var color : Color setget set_color

func _ready():
	set_color(color)
	visible = false

func activate():
	visible = true
	$Tween.interpolate_property(self, "color:a", 0.0, 1.0, 2)
	$Tween.start()

func set_color(col: Color):
	color = col
	for c in get_children():
		if c is MeshInstance:
			c = c as MeshInstance
			c.get_surface_material(0).set("shader_param/albedo", color)
