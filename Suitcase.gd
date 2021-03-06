extends Spatial

var maze_mode := true
var max_angle_degree := 8

func _ready():
	
	Game.main_weight_rack = $WeightRack
	Game.main_weight = $Weight
	$SuitcaseModel/OpenPivot.rotation_degrees = Vector3.ZERO
	$SuitcaseModel/OpenPivot/CloserThing.rotation_degrees = Vector3.ZERO
	
	$DrawerPuzzle1/Drawer.pull_out_immediately()
	$DrawerPuzzle3/Drawer.pull_out_immediately()
	
	#$Circles.visible = true

func _physics_process(_delta):
	if maze_mode:
		var mouse_pos := get_viewport().get_mouse_position()
		mouse_pos.x = 2.0 * (float(mouse_pos.x) / get_viewport().size.x) - 1.0
		mouse_pos.y = 2.0 * (float(mouse_pos.y) / get_viewport().size.y) - 1.0
		
		var x_target := mouse_pos.y * max_angle_degree
		var z_target := -mouse_pos.x * max_angle_degree
		
		rotation_degrees.x = lerp(rotation_degrees.x, x_target, .05)
		rotation_degrees.z = lerp(rotation_degrees.z, z_target, .05)

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
	$Buttons/Switch1.enabled = false
	$DrawerPuzzle1/Drawer.button_activated()
	yield($DrawerPuzzle1/Drawer, "pull_completed")
	$Buttons/Switch1.enabled = true

func _on_Switch2_switch_turned() -> void:
	$Buttons/Switch2.enabled = false
	$DrawerPuzzle2/Drawer.button_activated()
	yield($DrawerPuzzle2/Drawer, "pull_completed")
	$Buttons/Switch2.enabled = true

func _on_Switch3_switch_turned() -> void:
	$Buttons/Switch3.enabled = false
	$DrawerPuzzle3/Drawer.button_activated()
	yield($DrawerPuzzle3/Drawer, "pull_completed")
	$Buttons/Switch3.enabled = true


func _on_BoardPuzzle1_puzzle_won() -> void:
	Game.puzzle1_beaten = true
	# turn on LED 1
	$LED.set_light("Green", true)

func _on_BoardPuzzle2_puzzle_won() -> void:
	$Buttons/Button1.open = true

func _on_BoardPuzzle3_puzzle_won() -> void:
	Game.puzzle3_beaten = true
	$LED.set_light("Red", true)

func _on_BoardPuzzle4_puzzle_won() -> void:
	Game.puzzle2_beaten = true
	$LED.set_light("Blue", true)

func _on_Button1_button_pressed() -> void:
	# TODO deactivate button
	if Game.main_weight.at_start_pos:
		$CanvasLayer/Tool.rect_position = get_viewport().size/2 - $CanvasLayer/Tool.rect_size/2
		$CanvasLayer/Tool.visible = true
	$Buttons/Button1.enabled = false
	$DrawerPuzzle4/Drawer.button_activated()
	yield($DrawerPuzzle4/Drawer, "pull_completed")
	$Buttons/Button1.enabled = true
	
	if Game.main_weight.at_start_pos:
		yield(get_tree().create_timer(5.0), "timeout")
		$CanvasLayer/Tool.visible = false


func _on_reset_button_pressed() -> void:
	for i in [1, 2, 3, 4]:
		var node = get_node("DrawerPuzzle" + str(i))
		# only reset puzzles that haven't been solved yet
		if not node.has_node("Sound"):
			# dirty hack to see if it's been solved
			continue
		if node.get_node("Sound").playing:
			continue
		node.get_node("Drawer/BoardPuzzle" + str(i)).reset()
