extends Spatial

var pulled_out := false

export var PULL_DIRECTION: Vector3 = Vector3.RIGHT

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
	target_transform = self.transform.translated(PULL_DIRECTION * length)
	$Tween.reset_all()
	$Tween.interpolate_method(self, "move_global", 0.0, 1.0, 0.8, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$DrawerOpen.play()
	pulled_out = true
	

func pull_out_immediately():
	var aabb = $DrawerMesh.get_transformed_aabb()
	var length = aabb.get_longest_axis_size() / self.scale.x
	self.transform = self.transform.translated(PULL_DIRECTION * length)
	pulled_out = true

func pull_back():
	var aabb = $DrawerMesh.get_transformed_aabb()
	var length = aabb.get_longest_axis_size() / self.scale.x
	# TODO add some bounce to make it more interesting
	start_transform = Transform(self.transform)
	target_transform = self.transform.translated(-PULL_DIRECTION * length)
	$Tween.reset_all()
	$Tween.interpolate_method(self, "move_global", 0.0, 1.0, 0.6)
	$Tween.start()
	$DrawerClose.play()
	pulled_out = false


func _on_Tween_tween_all_completed() -> void:
	emit_signal("pull_completed")
