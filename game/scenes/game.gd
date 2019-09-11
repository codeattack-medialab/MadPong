extends Node2D

export(String, "No", "FullScreen", "Window") var medialab_facade := "No"

var score1 := 0
var score2 := 0


func _ready():
	$Racket1.player = 1
	$Racket2.player = 2
	$Score1.text = "0"
	$Score2.text = "0"

	$Racket1.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)
	$Racket2.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)

	if medialab_facade == "FullScreen" or medialab_facade == "Window":
		var viewport_size = Vector2(192+40, 157+40)
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_KEEP, viewport_size, 1)
		position = Vector2(40, 40)
	if medialab_facade == "FullScreen":
		OS.window_fullscreen = true
	elif medialab_facade == "Window":
		OS.window_position = Vector2(0, 0)
	elif medialab_facade == "No":
		OS.window_fullscreen = true
		position = Vector2(20, 20)


func _on_body_entered(body,extra_arg_0):
	$Ball.set_physics_process(false)
	match extra_arg_0:
		1:
			score1+=1
			$Score1.text= str(score1)
		2:
			score2+=1
			$Score2.text= str(score2)
	$Ball.position = $Ball.initial_pos
	$Timer.start()

