extends Spatial

export var flipped_in_beginning: bool = false

onready var is_flipped := false
export var random_flippiness = 5.5
onready var target_one = $Mesh.transform.rotated(Vector3.FORWARD, deg2rad(180.0 + (randf()-0.5)*random_flippiness))
onready var target_two = $Mesh.transform.rotated(Vector3.FORWARD, deg2rad((randf()-0.5)*random_flippiness))

signal flipped(x, y)

onready var x
onready var y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var coords = name.split('Tile')[1]
	x = int(coords[0])
	y = int(coords[1])

	$Mesh/Sprite3D.hframes = get_parent().dim_x
	$Mesh/Sprite3D.vframes = get_parent().dim_y
	# scale sprite
	if get_parent().dim_x == 4:
		$Mesh/Sprite3D.transform = $Mesh/Sprite3D.transform.scaled(Vector3(4.0/3.0, 1.0, 1.0))
	if get_parent().dim_y == 4:
		$Mesh/Sprite3D.transform = $Mesh/Sprite3D.transform.scaled(Vector3(1.0, 1.0, 4.0/3.0))
	$Mesh/Sprite3D.frame_coords = Vector2(y-1, x-1)

	if flipped_in_beginning:
		is_flipped = true
		$Mesh.transform = target_one


var target_z = PI
var target_transform: Transform
func flip_lerp(weight: float):
	$Mesh.transform = $Mesh.transform.interpolate_with(target_transform, weight)

func flip_visually():
	if $Tween.is_active():\
		$Tween.stop_all()
	target_transform = target_one if is_flipped else target_two
	$Tween.remove_all()
	$Tween.interpolate_method(self, "flip_lerp", 0.0, 1.0, 1.8, Tween.TRANS_LINEAR)
	$Tween.start()
#	$ClickArea.monitoring = false
#	$ClickArea.input_ray_pickable = false
	
func flip():
	is_flipped = not is_flipped
	flip_visually()

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
#	print("reached")
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:

			# either put a weight on this or flip it
			if Game.selected_weight != null: # weight is selected for movement
				var weight: Weight = Game.selected_weight
				weight.currently_selected = false
				Game.selected_weight = null
				
				weight.global_transform.origin.x = self.global_transform.origin.x
				weight.global_transform.origin.y = self.global_transform.origin.y
				weight.global_transform.origin.z = self.global_transform.origin.z
				Game.weight_x = x
				Game.weight_y = y
				var puzzle_name = get_parent().get_parent().get_parent().name
				Game.weight_puzzle = int(puzzle_name[-1])
				Game.clear_outline()
				$WeightDropSound.play()
			elif Game.weight_x == x and Game.weight_y == y: # weight is on this tile
				pass # do nothing
			else:  # flip
				flip()
				var pitch_strength = 0.5
				AudioServer.get_bus_effect(1, 0).pitch_scale = 1.0 + ((0.5 - randf()) * pitch_strength)
				$FlipSound.play()
				emit_signal("flipped", x, y)

func _on_ClickArea_mouse_exited() -> void:
	if Game.selected_weight != null:
		Game.toggle_outline(self, false, Game.WEIGHT_COLOR, 0.08)
	else:
		Game.toggle_outline(self, false)


func _on_ClickArea_mouse_entered() -> void:
	if Game.selected_weight != null:
		Game.toggle_outline(self, true, Game.WEIGHT_COLOR, 0.08)
	elif Game.weight_x != x or Game.weight_y != y:
		Game.toggle_outline(self, true)
