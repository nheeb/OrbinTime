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
	$Tween.reset_all()
	target = $Pivot/Position3D.transform
	start = Transform($Pivot/Camera.transform)
	pivot_start = Transform($Pivot.transform)
	$Tween.interpolate_method(self, "interpolate", 0.0, 1.0, 2.5)
	$Tween.start()

func _physics_process(delta):
	var dist_to_finish :float = $Orb.global_transform.origin.distance_to($Suitcase/MazeFinish.global_transform.origin)
	if dist_to_finish < finish_range and $Suitcase.maze_mode:
		$Suitcase.open()
		yield($Suitcase/SuitcaseModel/AnimationPlayer, "animation_finished")  
		move_camera_to_base_pos()
		
	if Input.is_action_just_pressed("teleport_orb"):
		$Orb.global_transform.origin = $Suitcase/MazeFinish.global_transform.origin
