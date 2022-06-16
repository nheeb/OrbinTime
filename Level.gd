extends Spatial

var finish_range := .01


# target transform
var start: Transform
var pivot_start
var target: Transform

func interpolate(weight):
	$Pivot/Camera.transform = start.interpolate_with(target, weight)
	$Pivot.transform = pivot_start.interpolate_with($PivotTarget.transform, weight)

func move_camera_to_base_pos():
#	$Tween.reset_all()
#	$Tween.remove_all()
	target = $Pivot/Position3D.transform
	start = Transform($Pivot/Camera.transform)
	pivot_start = Transform($Pivot.transform)
	$Tween.interpolate_method(self, "interpolate", 0.0, 1.0, 2.5)
	$Tween.start()

var maze_mode := true

func _physics_process(delta):
	if maze_mode:
		var dist_to_finish :float = $Orb.global_transform.origin.distance_to($Suitcase/MazeFinish.global_transform.origin)
		if dist_to_finish < finish_range:
			maze_mode = false
			$Suitcase.straight()
			# orb spin active
			$Orb.mode = RigidBody.MODE_STATIC
			$Orb/AnimationPlayer.play("spin")
			# orb fly to camera
			var fly_duration := 3.3
			$Tween.interpolate_property($Orb, "global_transform:origin:x", $Orb.global_transform.origin.x, $Pivot/Camera/OrbFlyTarget.global_transform.origin.x, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:z", $Orb.global_transform.origin.z, $Pivot/Camera/OrbFlyTarget.global_transform.origin.z, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:y", $Orb.global_transform.origin.y, $Pivot/Camera/OrbFlyTarget.global_transform.origin.y, fly_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Tween.interpolate_property($Orb, "scale", Vector3.ONE, 2*Vector3.ONE, fly_duration)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			$Suitcase.open()
			yield($Suitcase/SuitcaseModel/AnimationPlayer, "animation_finished")
			$Tween.interpolate_property($Orb, "global_transform:origin:x", $Orb.global_transform.origin.x, $Suitcase/Main/SocketModel/OrbTarget.global_transform.origin.x, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:z", $Orb.global_transform.origin.z, $Suitcase/Main/SocketModel/OrbTarget.global_transform.origin.z, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:y", $Orb.global_transform.origin.y, $Suitcase/Main/SocketModel/OrbTarget.global_transform.origin.y, fly_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
			$Tween.start()
			yield(get_tree().create_timer(.7), "timeout")
			move_camera_to_base_pos()
			
		if Input.is_action_just_pressed("teleport_orb"):
			$Orb.global_transform.origin = $Suitcase/MazeFinish.global_transform.origin
