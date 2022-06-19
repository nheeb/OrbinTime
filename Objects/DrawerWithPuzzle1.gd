extends Spatial

export var target_color: Color


func _on_BoardPuzzle_puzzle_won() -> void:
	Game.turn_orb_on($Drawer/SolutionOrb.get_active_material(0), target_color)
	if has_node("Sound"):
		$Sound.play()
		$Sound.queue_free()
