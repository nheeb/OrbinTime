extends Spatial

var pulled_out := false

# could be relevant to disable button while the drawer is moving
signal pull_completed

func _ready() -> void:
	pass 


var start_transform: Transform
var target_transform: Transform
func move_global(weight):
	self.transform = start_transform.interpolate_with(target_transform, weight)


func button_activated():
	if not pulled_out:
		pull_out()
	else:
		pull_back()

func pull_out():
	var aabb = $DrawerMesh.get_transformed_aabb()
	var length = aabb.get_longest_axis_size() / self.scale.x
	# TODO add some bounce to make it more interesting
	start_transform = Transform(self.transform)
	target_transform = self.transform.translated(Vector3.RIGHT * length)
	$Tween.reset_all()
	$Tween.interpolate_method(self, "move_global", 0.0, 1.0, 1.5)
	$Tween.start()
	pulled_out = true
	
	
func pull_back():
	var aabb = $DrawerMesh.get_transformed_aabb()
	var length = aabb.get_longest_axis_size() / self.scale.x
	# TODO add some bounce to make it more interesting
	start_transform = Transform(self.transform)
	target_transform = self.transform.translated(Vector3.LEFT * length)
	$Tween.reset_all()
	$Tween.interpolate_method(self, "move_global", 0.0, 1.0, 1.5)
	$Tween.start()
	pulled_out = false


func _on_Tween_tween_all_completed() -> void:
	emit_signal("pull_completed")
