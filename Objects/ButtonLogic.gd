extends Spatial

export var button_press_depth := 0.5

var is_pressed := false

signal button_pressed

var open := false setget set_open

func set_open(o):
	if open != o:
		open = o
		if open:
			$Tween.interpolate_property($EdgeButtonModel/Pivot, "rotation_degrees:x", 0, -110, 1.5,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			$Tween.start()
	

func pressed():
	# for now move the buttonTop immediately down
	# for more fanciness we could use a Tween
	$EdgeButtonModel/EdgeButtonTop.translate(Vector3.DOWN * button_press_depth)
	$PushSound.play()
	is_pressed = true
	emit_signal("button_pressed")
	
	
func released():
	$EdgeButtonModel/EdgeButtonTop.translate(-Vector3.DOWN * button_press_depth)
	$ReleaseSound.play()
	is_pressed = false

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if open:
		if event is InputEventMouseButton:
			if event.button_index == 1:
				if event.pressed and not is_pressed and open:
					pressed()
				elif is_pressed and open:
					released() 


func _on_ClickArea_mouse_exited() -> void:
	if open:
		Game.toggle_outline(self, false)
		if is_pressed:
			released()


func _on_ClickArea_mouse_entered() -> void:
	if open:
		Game.toggle_outline(self, true)
