extends Spatial

export var target_color: Color

func _on_BoardPuzzle1_puzzle_won() -> void:
	Game.turn_orb_on($Drawer/SolutionOrb.get_active_material(0), target_color)
