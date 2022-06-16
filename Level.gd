extends Spatial

var finish_range := .01

func _physics_process(delta):
	var dist_to_finish :float = $Orb.global_transform.origin.distance_to($Suitcase/MazeFinish.global_transform.origin)
	if dist_to_finish < finish_range and $Suitcase.maze_mode:
		$Suitcase.open()
