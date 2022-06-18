extends Spatial

export var turn_angle := 30  # degrees

var is_turned_on := false

signal switch_turned_on
signal switch_turned_off

func flip_visually():
	# TODO could be tweened to be more fancy
	var rotation = 2*turn_angle if is_turned_on else -2*turn_angle
	$SwitchModel/Switch.rotate_x(deg2rad(rotation))

	
func flip():
	flip_visually()
	is_turned_on = not is_turned_on
	if is_turned_on:
		emit_signal("switch_turned_on")
	else:
		emit_signal("switch_turned_off")

	
	
#func released():
#	$EdgeButtonModel/EdgeButtonTop.translate(-Vector3.DOWN * button_press_depth)
#	is_pressed = false

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				flip()
