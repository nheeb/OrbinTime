extends Spatial

export var target_color: Color

func _ready():
	if has_node("Drawer/Lamp/Light"):
		$Drawer/Lamp/Light.light_energy = 0.0

func _on_BoardPuzzle_puzzle_won() -> void:
	Game.turn_orb_on($Drawer/SolutionOrb.get_active_material(0), target_color)
	if has_node("Drawer/Lamp/Light"):
		$Drawer/Lamp/Light.light_energy = 1.0
	if has_node("Sound"):
		if not $Sound.playing:
			$Sound.play()
			yield($Sound, "finished")
			$Sound.queue_free()
