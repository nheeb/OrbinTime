extends Spatial

export var button_press_depth := 0.5

var is_pressed := false

signal button_pressed

func pressed():
	# for now move the buttonTop immediately down
	# for more fanciness we could use a Tween
	$EdgeButtonModel/EdgeButtonTop.translate(Vector3.DOWN * button_press_depth)
	is_pressed = true
	emit_signal("button_pressed")
	
func released():
	$EdgeButtonModel/EdgeButtonTop.translate(-Vector3.DOWN * button_press_depth)
	is_pressed = false

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed and not is_pressed:
				pressed()
			elif is_pressed:
				released() 


func _on_ClickArea_mouse_exited() -> void:
	if is_pressed:
		released()
