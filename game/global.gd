extends Node

var current_scene

func _ready():
	randomize()

	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	root.connect("size_changed", self, "_on_size_changed")

func go_to_scene(new_scene):
	call_deferred("_deferred_go_to_scene", new_scene)

func _deferred_go_to_scene(new_scene):
	current_scene.free()
	current_scene = load(new_scene).instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func _on_size_changed():
	var rect: Rect2 = current_scene.get_viewport_rect()
	var width: int = ProjectSettings.get_setting("display/window/size/width")
	var height: int = ProjectSettings.get_setting("display/window/size/height")
	var x := (rect.size.x - width) / 2.0
	var y := (rect.size.y - height) / 2.0
	current_scene.position = Vector2(x, y)
