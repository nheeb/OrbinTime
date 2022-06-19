extends RigidBody

var do_grass := true
var do_mountains := true
var do_trees := true
var do_rivers := true

const TREE = preload("res://Objects/Tree.tscn")

#func _ready():
#	$AnimationPlayer.play("spin")
#	become_planet()

signal planet_done

func become_planet():
	if do_grass:
		$Tween.interpolate_property($OrbBlackModel/Sphere.mesh.surface_get_material(0), "shader_param/paint_value", 0.0, 1.0, 4.0)
		$Tween.start()
		yield($Tween,"tween_all_completed")
		yield(get_tree().create_timer(.5),"timeout")
	if do_mountains:
		$Tween.interpolate_property($OrbBlackModel/Sphere.mesh.surface_get_material(0), "shader_param/mountain_value", 0.0, 1.0, 3.0)
		$Tween.start()
		$MountainSound.play()
		yield($Tween,"tween_all_completed")
		yield(get_tree().create_timer(.5),"timeout")
	if do_trees:
		var trees := []
		trees.append_array($OrbBlackModel/Trees.get_children())
		trees.shuffle()
		$TreeSound.play()
		for t in trees:
			var dir : Vector3 = t.translation.normalized()
			var tree := TREE.instance()
			$OrbBlackModel.add_child(tree)
			tree.transform = Transform.IDENTITY.looking_at(dir, Vector3.UP)
			tree.transform.origin = dir * .85
			tree.grow()
			yield(get_tree().create_timer(.2),"timeout")
	yield(get_tree().create_timer(1.0),"timeout")
	if do_rivers:
		$OceanSound.play()
		$OrbBlackModel/Water.visible = true
		$Tween.interpolate_property($OrbBlackModel/Sphere.mesh.surface_get_material(0), "shader_param/river_value", 0.0, 1.0, 3.5)
		$Tween.start()
		yield($Tween,"tween_all_completed")
	emit_signal("planet_done")

func revert():
	if do_grass:
		$Tween.interpolate_property($OrbBlackModel/Sphere.mesh.surface_get_material(0), "shader_param/paint_value", 1.0, 0.0, 4.0)
	if do_mountains:
		$Tween.interpolate_property($OrbBlackModel/Sphere.mesh.surface_get_material(0), "shader_param/mountain_value", 1.0, 0.0, 3.0)
	if do_rivers:
		$Tween.interpolate_property($OrbBlackModel/Sphere.mesh.surface_get_material(0), "shader_param/river_value", 1.0, 0.0, 3.5)
	$Tween.start()
	if do_trees:
		var trees := []
		trees.append_array($OrbBlackModel/Trees.get_children())
		trees.shuffle()
		for t in trees:
			if t is MeshInstance:
				t.queue_free()
				yield(get_tree().create_timer(.2),"timeout")
