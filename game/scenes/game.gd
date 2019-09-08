extends Node2D

export var medialab_facade := false

var score1 := 0
var score2 := 0


func _init():
	OS.window_fullscreen = true


func _ready():
	$Racket1.player = 1
	$Racket2.player = 2
	$Score1.text = "0"
	$Score2.text = "0"

	$Racket1.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)
	$Racket2.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)

	if medialab_facade:
		var viewport_size = Vector2(192+40, 157+40)
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_KEEP, viewport_size, 1)
		position = Vector2(40, 40)
	else:
		position = Vector2(20, 20)
