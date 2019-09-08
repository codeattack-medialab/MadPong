extends Node

var current_scene


func _ready():
	randomize()

	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func go_to_scene(new_scene):
	call_deferred("_deferred_go_to_scene", new_scene)


func _deferred_go_to_scene(new_scene):
	current_scene.free()
	current_scene = load(new_scene).instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
