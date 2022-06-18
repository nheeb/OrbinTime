extends Node

var selected_weight: Weight = null
var weight_x = -1
var weight_y = -1

const OUTLINE = preload("res://Assets/Materials/OutlineMat.tres")

func toggle_outline(object: Spatial, value: bool, color: Color = Color.ghostwhite, width : float = 0.05) -> void:
	if value:
		object.add_to_group("outlined")
	else:
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
			mat.next_pass = outline_mat if value else null

func clear_outline():
	for member in get_tree().get_nodes_in_group("outlined"):
		toggle_outline(member, false)

func make_materials_right(mi: MeshInstance):
	if mi.get_surface_material(0) == null:
		for i in mi.get_surface_material_count():
			mi.set_surface_material(i, mi.mesh.surface_get_material(i).duplicate(false))

func fetch_all_child_mesh_instances(object: Node) -> Array:
	var mesh_instances := []
	if object is MeshInstance:
		mesh_instances.append(object)
	for c in object.get_children():
		mesh_instances.append_array(fetch_all_child_mesh_instances(c))
	return mesh_instances

func _physics_process(delta):
	if Input.is_action_just_pressed("clear_selection"):
		clear_outline()
