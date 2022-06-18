extends Spatial

var start_scale := Vector3.ONE * .1
var end_scale := Vector3.ONE * 1.5
var duration := 1.5

func _ready():
	visible = false

func grow():

	$Tween.interpolate_property(self, "scale", start_scale, end_scale, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(.1),"timeout")
	visible = true
