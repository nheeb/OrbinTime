extends Spatial

func open():
	$Tween.interpolate_property($Pivot, "rotation_degrees:z", 0, 50, 1, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.start()

func close():
	yield(get_tree().create_timer(.2),"timeout")
	$Tween.interpolate_property($Pivot, "rotation_degrees:z", 50, 0, .8, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()
