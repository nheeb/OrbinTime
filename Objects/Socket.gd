extends Spatial


signal ending_initiated# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if Game.level.view_mode:
					# TODO: check if there is at least 1 puzzle solved
					emit_signal("ending_initiated")
					Game.toggle_outline(self, false)


func _on_ClickArea_mouse_entered() -> void:
	if Game.level.view_mode:
		if Game.puzzle1_beaten or Game.puzzle2_beaten or Game.puzzle3_beaten:
			Game.toggle_outline(self, true)


func _on_ClickArea_mouse_exited() -> void:
	if Game.level.view_mode:
		if Game.puzzle1_beaten or Game.puzzle2_beaten or Game.puzzle3_beaten:
			Game.toggle_outline(self, false)
