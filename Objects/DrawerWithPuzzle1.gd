extends Spatial

export var target_color: Color

# could be made into a generic func in Game
func turn_orb_on():
	var mat: Material = $Drawer/SolutionOrb.mesh.surface_get_material(0)
	$Tween.reset_all()
	$Tween.interpolate_property(mat, "albedo", null, target_color, 0.6, Tween.TRANS_BOUNCE)
	$Tween.start()
	# after that transition it should change color a little / glow for a nice effect


func _on_BoardPuzzle1_puzzle_won() -> void:
	print("puzzle 1 won")
	turn_orb_on()
