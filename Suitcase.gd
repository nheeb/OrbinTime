extends Spatial

var maze_mode := true
var max_angle_degree := 10

func _ready():
	$SuitcaseModel/OpenPivot.rotation_degrees = Vector3.ZERO
	$SuitcaseModel/OpenPivot/CloserThing.rotation_degrees = Vector3.ZERO

func _physics_process(_delta):
	if maze_mode:
		var mouse_pos := get_viewport().get_mouse_position()
		mouse_pos.x = 2.0 * (float(mouse_pos.x) / get_viewport().size.x) - 1.0
		mouse_pos.y = 2.0 * (float(mouse_pos.y) / get_viewport().size.y) - 1.0
		
		var x_target := mouse_pos.y * max_angle_degree
		var z_target := -mouse_pos.x * max_angle_degree
		
#		rotation_degrees.x = lerp(rotation_degrees.x, x_target, .1)
#		rotation_degrees.z = lerp(rotation_degrees.z, z_target, .1)
		rotation_degrees.x = x_target
		rotation_degrees.z = z_target

		rotation_degrees.y = 0

func open():
	$SuitcaseModel/AnimationPlayer.play("open")

func straight():
	maze_mode = false
	$Tween.interpolate_property(self, "rotation_degrees:x", rotation_degrees.x, 0.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "rotation_degrees:z", rotation_degrees.z, 0.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	change_to_long()

func _on_ButtonDrawer_button_pressed() -> void:
	$Drawer.button_activated()


func change_to_long():
	$SuitcaseModel/SuitcaseLong.visible =true
	$SuitcaseModel/Suitcase.visible = false


func _on_Switch_switch_turned() -> void:
	$Buttons/Switch.enabled = false
	$Drawer.button_activated()
	yield($Drawer, "pull_completed")
	$Buttons/Switch.enabled = true
