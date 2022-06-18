extends Node

var puzzle1_beaten = false
var puzzle2_beaten = false
var puzzle3_beaten = false


export var WEIGHT_COLOR := Color("384a51")
var selected_weight: Weight = null
var weight_x = -1
var weight_y = -1

const OUTLINE = preload("res://Assets/Materials/OutlineMat.tres")

func toggle_outline(object: Spatial, value: bool, color: Color = Color.ghostwhite, width : float = 0.05) -> void:
	if value:
		object.add_to_group("outlined")
	else:
		if object.is_in_group("outlined"):
			object.remove_from_group("outlined")
	var outline_mat : ShaderMaterial = OUTLINE.duplicate(true)
	outline_mat.set("shader_param/outline_width", width)
	outline_mat.set("shader_param/outline_color", color)
	var mesh_instances := fetch_all_child_mesh_instances(object)
	for _m in mesh_instances:
		var mi := _m as MeshInstance
		make_materials_right(mi)
		for i in range(mi.get_surface_material_count()):
			var mat := mi.get_surface_material(i)
			if mat != null:
				mat.next_pass = outline_mat if value else null

func clear_outline():
	for member in get_tree().get_nodes_in_group("outlined"):
		toggle_outline(member, false)

func make_materials_right(mi: MeshInstance):
	if mi.get_surface_material(0) == null:
		for i in mi.get_surface_material_count():
			if mi.mesh != null:
				var surface_mat = mi.mesh.surface_get_material(i)
				if surface_mat != null:
					mi.set_surface_material(i, surface_mat.duplicate(false))

func fetch_all_child_mesh_instances(object: Node) -> Array:
	var mesh_instances := []
	if object is MeshInstance:
		mesh_instances.append(object)
	for c in object.get_children():
		mesh_instances.append_array(fetch_all_child_mesh_instances(c))
	return mesh_instances

func _physics_process(_delta):
	if Input.is_action_just_pressed("clear_selection"):
		clear_outline()
		
# could be made into a generic func in Game
func turn_orb_on(mat:SpatialMaterial, target_color):
	$Tween.reset_all()
	$Tween.interpolate_property(mat, "albedo_color", mat.albedo_color, target_color, 0.6, Tween.TRANS_BOUNCE)
	$Tween.start()
	# after that transition it should change color a little / glow for a nice effect

