extends Spatial
class_name Weight

export var WEIGHT_COLOR := Color("384a51")
var currently_selected = false
var at_start_pos = true
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_teleport():
	self.global_transform.origin = Game.main_weight_rack.global_transform.origin
	Game.level.get_node("WeightSpotlight").visible = false
	$WeightDropSound.play()
	at_start_pos = false

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if at_start_pos:
				# only pickup if no puzzle is active
				if not Game.level.get_node("Suitcase/DrawerPuzzle1/Drawer").pulled_out and not Game.level.get_node("Suitcase/DrawerPuzzle1/Drawer").pulled_out and not Game.level.get_node("Suitcase/DrawerPuzzle3/Drawer").pulled_out and not Game.level.get_node("Suitcase/DrawerPuzzle4/Drawer").pulled_out:
					start_teleport()
					return
			currently_selected = not currently_selected
			if currently_selected:
				# TODO outline shader tiles ON
				Game.toggle_outline(self, true)
				Game.selected_weight = self
				
				Game.toggle_outline(Game.level.get_node("Suitcase/WeightRack"),true, Game.WEIGHT_COLOR, 0.08)
				
				# outline all tiles in orange or smth
				for node in get_tree().get_nodes_in_group("tile"):
					if node.clickable:
						Game.toggle_outline(node, true, Game.WEIGHT_COLOR, 0.08)
					# TODO clear this


func _on_ClickArea_mouse_entered() -> void:
	if not currently_selected:
		Game.toggle_outline(self, true)


func _on_ClickArea_mouse_exited() -> void:
	if not currently_selected:
		Game.toggle_outline(self, false)
