extends Spatial

export var target_color: Color


func _on_BoardPuzzle_puzzle_won() -> void:
	Game.turn_orb_on($Drawer/SolutionOrb.get_active_material(0), target_color)


func _on_BoardPuzzle3_puzzle_won() -> void:
	pass # Replace with function body.