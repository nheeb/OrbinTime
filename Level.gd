extends Spatial

var finish_range := .02

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


func move_camera_to_ending_pos():
#	$Tween.reset_all()
#	$Tween.remove_all()
	target = Transform($Pivot/CameraEnding.transform)
	start = Transform($Pivot/Camera.transform)
	pivot_start = Transform($Pivot.transform)
	$Tween.interpolate_method(self, "interpolate", 0.0, 1.0, 2.5)
	$Tween.start()

var maze_mode := false

func _ready():
	Game.level = self
	$Suitcase.maze_mode = false
	$Orb.visible = false
	$Orb.mode = RigidBody.MODE_STATIC
	var suitcase_target : Vector3 = $Suitcase.global_transform.origin
	$Suitcase.global_transform.origin = $SuitcaseSpawn.global_transform.origin
	$Suitcase.transform.basis = Transform.IDENTITY.rotated(Vector3(1, .5, 0).normalized(), 70).basis
	$Tween.interpolate_property($Suitcase, "global_transform:origin:x", $Suitcase.global_transform.origin.x, suitcase_target.x, 5)
	$Tween.interpolate_property($Suitcase, "global_transform:origin:z", $Suitcase.global_transform.origin.z, suitcase_target.z, 5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property($Suitcase, "global_transform:origin:y", $Suitcase.global_transform.origin.y, suitcase_target.y, 5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Suitcase, "transform:basis", $Suitcase.transform.basis, Basis.IDENTITY, 5)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Orb.visible = true
	$Orb.global_transform.origin = $Suitcase/SuitcaseModel/OpenPivot/Maze/StaticBody/OrbSpawnPosition.global_transform.origin
	yield(get_tree().create_timer(.5),"timeout")
	maze_mode = true
	$Suitcase.maze_mode = true
	$Orb.mode = RigidBody.MODE_RIGID
	var _e = $Suitcase/Main/SocketModel.connect("ending_initiated", self, "ending_initiated")

var ending_mode := false
func ending_initiated():
	if Game.puzzle1_beaten or Game.puzzle2_beaten or Game.puzzle3_beaten:
		view_mode = false
		move_camera_to_ending_pos()
		yield($Tween, "tween_all_completed")
		$Suitcase/Main/SocketModel/AnimationPlayer.play("busy")
		$Orb.do_trees = Game.puzzle1_beaten
		$Orb.do_rivers = Game.puzzle2_beaten
		$Orb.do_mountains = Game.puzzle3_beaten
		$Orb.become_planet()
		yield($Orb, "planet_done")
		$Suitcase/EndingText.set_but_text(Game.puzzle3_beaten , Game.puzzle1_beaten , Game.puzzle2_beaten)
		$Suitcase/EndingText.animate()
		yield(get_tree().create_timer(3),"timeout")
		ending_mode = true

func _input(event):
	if event is InputEventMouseButton:
		if ending_mode:
			if !Game.puzzle1_beaten or !Game.puzzle2_beaten or !Game.puzzle3_beaten:
				ending_mode = false
				move_camera_to_base_pos()
				$Orb.revert()
				yield($Tween, "tween_all_completed")
				view_mode = true
				$Suitcase/EndingText.visible = false
				$Suitcase/Main/SocketModel/AnimationPlayer.play("idle")


var view_mode := false
var max_move := .03
var cam_global_pos : Vector3
func _physics_process(_delta):
	if Input.is_action_just_pressed("ending"):
		$Suitcase/Circles.queue_free()
	if view_mode:
		var mouse_pos := get_viewport().get_mouse_position()
		mouse_pos.x = 2.0 * (float(mouse_pos.x) / get_viewport().size.x) - 1.0
		mouse_pos.y = 2.0 * (float(mouse_pos.y) / get_viewport().size.y) - 1.0
		
		var x_target := mouse_pos.x * max_move + cam_global_pos.x
		var z_target := mouse_pos.y * max_move + cam_global_pos.z
		
		$Pivot/Camera.global_transform.origin.x = lerp($Pivot/Camera.global_transform.origin.x, x_target, .02)
		$Pivot/Camera.global_transform.origin.z = lerp($Pivot/Camera.global_transform.origin.z, z_target, .02)
	
	if maze_mode:
		var dist_to_finish :float = $Orb.global_transform.origin.distance_to($Suitcase/MazeFinish.global_transform.origin)
		if dist_to_finish < finish_range:
			maze_mode = false
			$UnlockSound.play()
			$Suitcase.straight()
			# orb spin active
			$Orb.mode = RigidBody.MODE_STATIC
			$Orb/AnimationPlayer.play("spin")
			# orb fly up
			$Tween.interpolate_property($Orb, "global_transform:origin:y", $Orb.global_transform.origin.y, $Orb.global_transform.origin.y+.1, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			# orb fly to camera
			var fly_duration := 3.3
			$OrbDroneSound.play()
			$Tween.interpolate_property($Orb, "global_transform:origin:x", $Orb.global_transform.origin.x, $Pivot/Camera/OrbFlyTarget.global_transform.origin.x, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:z", $Orb.global_transform.origin.z, $Pivot/Camera/OrbFlyTarget.global_transform.origin.z, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:y", $Orb.global_transform.origin.y, $Pivot/Camera/OrbFlyTarget.global_transform.origin.y, fly_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Tween.interpolate_property($Orb, "scale", Vector3.ONE, 2.5*Vector3.ONE, fly_duration)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			$Suitcase.open()
			yield($Suitcase/SuitcaseModel/AnimationPlayer, "animation_finished")
			$Tween.interpolate_property($Orb, "global_transform:origin:x", $Orb.global_transform.origin.x, $Suitcase/Main/SocketModel/OrbTarget.global_transform.origin.x, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:z", $Orb.global_transform.origin.z, $Suitcase/Main/SocketModel/OrbTarget.global_transform.origin.z, fly_duration)
			$Tween.interpolate_property($Orb, "global_transform:origin:y", $Orb.global_transform.origin.y, $Suitcase/Main/SocketModel/OrbTarget.global_transform.origin.y, fly_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
			$Tween.start()
			yield(get_tree().create_timer(.7), "timeout")
			$Suitcase/SuitcaseModel/OpenPivot/Maze.queue_free()
			$Suitcase/SuitcaseModel/Belt.visible = false
			move_camera_to_base_pos()
			yield($Tween, "tween_all_completed")
			$Suitcase/Circles.activate()
			cam_global_pos = $Pivot/Camera.global_transform.origin
			view_mode=true
			
		if Input.is_action_just_pressed("teleport_orb") or $Orb.global_transform.origin.y < -2:
			$Orb.global_transform.origin = $Suitcase/MazeFinish.global_transform.origin

