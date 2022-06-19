extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if Game.selected_weight != null: # Weight is selected and will be dropped off here
				var weight: Weight = Game.selected_weight
				weight.global_transform.origin.x = global_transform.origin.x
				weight.global_transform.origin.y = global_transform.origin.y
				weight.global_transform.origin.z = global_transform.origin.z
				Game.selected_weight = null
				weight.currently_selected = false
				Game.weight_x = -1
				Game.weight_y = -1
				Game.weight_puzzle = -1
				Game.clear_outline()
				$WeightDropSound.play()
			else:
				pass # do nothing (?)
				


func _on_ClickArea_mouse_entered() -> void:
	if Game.selected_weight != null: # Weight is selected and will be dropped off here
		Game.toggle_outline(self, true, Game.WEIGHT_COLOR, 0.08)


func _on_ClickArea_mouse_exited() -> void:
	Game.toggle_outline(self, false)
