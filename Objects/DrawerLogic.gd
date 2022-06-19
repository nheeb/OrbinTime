extends Spatial

var pulled_out := false

export var PULL_DIRECTION: Vector3 = Vector3.RIGHT

# could be relevant to disable button while the drawer is moving
signal pull_completed

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
	var length
	if PULL_DIRECTION == Vector3(0.0, 0.0, 1.0):
		length = aabb.size.z / self.scale.z
	else:
		length = aabb.get_longest_axis_size() / self.scale.x
	# TODO add some bounce to make it more interesting
	start_transform = Transform(self.transform)
	target_transform = self.transform.translated(PULL_DIRECTION * length)
	$Tween.reset_all()
	$Tween.interpolate_method(self, "move_global", 0.0, 1.0, .9, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$DrawerOpen.play()
	pulled_out = true
	if Game.level.has_node("Suitcase/Klappe" + get_parent().name[-1]):
		Game.level.get_node("Suitcase/Klappe" + get_parent().name[-1]).open()
	if has_node("Lamp/Light"):
		$LightTween.interpolate_property(get_node("Lamp/light"), "light_energy", 0.0, 5.0, .5)
		$LightTween.start()

func pull_out_immediately():
	var aabb = $DrawerMesh.get_transformed_aabb()
	var length = aabb.get_longest_axis_size() / self.scale.x
	self.transform = self.transform.translated(PULL_DIRECTION * length)
	pulled_out = true
	var level=get_parent().get_parent().get_parent()
	if level.has_node("Suitcase/Klappe" + get_parent().name[-1]):
		level.get_node("Suitcase/Klappe" + get_parent().name[-1]).open()
	if has_node("Lamp/Light"):
		$LightTween.interpolate_property(get_node("Lamp/light"), "light_energy", 0.0, 5.0, .5)
		$LightTween.start()

func pull_back():
	var aabb = $DrawerMesh.get_transformed_aabb()
	var length = aabb.get_longest_axis_size() / self.scale.x
	# if the weight is on this drawer, port it back to the weight
	var puzzle_number = int(get_parent().name[-1])

	if puzzle_number == Game.weight_puzzle:
		# port weight back
		Game.main_weight.global_transform.origin = Game.main_weight_rack.global_transform.origin
		Game.weight_x = -1
		Game.weight_y = -1
		Game.weight_puzzle = -1
		
	if PULL_DIRECTION == Vector3(0.0, 0.0, 1.0):
		length = aabb.size.z / self.scale.z
	else:
		length = aabb.get_longest_axis_size() / self.scale.x
	start_transform = Transform(self.transform)
	target_transform = self.transform.translated(-PULL_DIRECTION * length)
	$Tween.reset_all()
	$Tween.interpolate_method(self, "move_global", 0.0, 1.0, 0.6)
	$Tween.start()
	$DrawerClose.play()
	pulled_out = false
	if Game.level.has_node("Suitcase/Klappe" + get_parent().name[-1]):
		Game.level.get_node("Suitcase/Klappe" + get_parent().name[-1]).close()
	if has_node("Lamp/Light"):
		$LightTween.interpolate_property(get_node("Lamp/light"), "light_energy", 5.0, 0.0, .5)
		$LightTween.start()


func _on_Tween_tween_all_completed() -> void:
	emit_signal("pull_completed")
