extends Spatial

func _ready() -> void:
	pass 


var start_transform: Transform
var target_transform: Transform
func move_global(weight):
	self.transform = start_transform.interpolate_with(target_transform, weight)

func pull_out():
	var aabb = $DrawerMesh.get_transformed_aabb()
	var length = aabb.get_longest_axis_size() / self.scale.x
	print("length: ", length)
	# TODO add some bounce to make it more interesting
	start_transform = Transform(self.transform)
	target_transform = self.transform.translated(Vector3.RIGHT * length)
	$Tween.reset_all()
	$Tween.interpolate_method(self, "move_global", 0.0, 1.0, 3.0)
	$Tween.start()
