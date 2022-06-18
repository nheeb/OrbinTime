extends Spatial

export var turn_angle := 30  # degrees

var is_turned_on := false
# disable the switch while the drawer is moving
var enabled := true

signal switch_turned_on
signal switch_turned_off

func flip_visually():
	# TODO could be tweened to be more fancy
	var rotation = 2*turn_angle if is_turned_on else -2*turn_angle
	$SwitchModel/Switch.rotate_x(deg2rad(rotation))
	Game.clear_outline()

	
func flip():
	flip_visually()
	is_turned_on = not is_turned_on
	if is_turned_on:
		emit_signal("switch_turned_on")
	else:
		emit_signal("switch_turned_off")

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if enabled:
					flip()


func _on_ClickArea_mouse_entered() -> void:
	if enabled:
		Game.toggle_outline(self, true)


func _on_ClickArea_mouse_exited() -> void:
	if enabled:
		Game.toggle_outline(self, false)
