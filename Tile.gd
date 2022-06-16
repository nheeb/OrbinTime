extends Spatial

onready var is_flipped := false
export var random_flippiness = 10.5
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
	

var target_z = PI
var target_transform: Transform
func flip_lerp(weight: float):
	$Mesh.transform = $Mesh.transform.interpolate_with(target_transform, weight)

func flip_visually():
	if $Tween.is_active():
		print("reset tween")
		$Tween.stop_all()
	target_transform = target_one if is_flipped else target_two

	$Tween.interpolate_method(self, "flip_lerp", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR)
	$Tween.start()
#	$ClickArea.monitoring = false
#	$ClickArea.input_ray_pickable = false
	
func flip():
	is_flipped = not is_flipped
	flip_visually()

func _on_ClickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
#	print("reached")
	if event is InputEventMouseButton:
		if event.pressed:
			flip()
			emit_signal("flipped", x, y)


func _on_Tween_tween_all_completed() -> void:
#	$ClickArea.monitoring = true
#	$ClickArea.input_ray_pickable = true
	pass
