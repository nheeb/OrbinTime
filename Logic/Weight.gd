extends Spatial
class_name Weight

export var WEIGHT_COLOR := Color("384a51")
var currently_selected = false
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			currently_selected = not currently_selected
			if currently_selected:
				# TODO outline shader tiles ON
				Game.toggle_outline(self, true)
				Game.selected_weight = self


func _on_ClickArea_mouse_entered() -> void:
	if not currently_selected:
		Game.toggle_outline(self, true)


func _on_ClickArea_mouse_exited() -> void:
	if not currently_selected:
		Game.toggle_outline(self, false)
