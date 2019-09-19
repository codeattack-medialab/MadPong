extends Node2D

export(String, "No", "FullScreen", "Window") var medialab_facade := "No"
export var max_score:= 3
var score1 := 0
var score2 := 0
var finished := false

var final_box

var udp
var pid
var dest_ip
var dest_port


signal joystick #eñal que envía a las raquetas el valo

func _enter_tree():
	if medialab_facade == "FullScreen":
		var viewport_size = Vector2(192+40, 157+40)
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_KEEP, viewport_size, 1)
		position = Vector2(40, 40)
		OS.window_fullscreen = true
	elif medialab_facade == "Window":
		OS.window_position = Vector2(40, 40)
	elif medialab_facade == "No":
		OS.window_fullscreen = true


func _ready():
	$Racket1.player = 1
	$Racket2.player = 2
	$Score1.text = "0"
	$Score2.text = "0"

	$Racket1.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)
	$Racket2.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)
	
	#UDP
	udp = PacketPeerUDP.new()
	var err = udp.listen(33333, "127.0.0.1")
	if err != OK:
		print("error al conectarse al puerto 33333")
	else:
		print("oko")
		
		
	

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
	if check_finish():
		finish_game()
	else:
		$Timer.start()
	
func check_finish() -> bool:
	if(max(score1,score2)>=max_score):
		return true
	else:
		return false
		
func finish_game():
	final_box = preload("res://scenes/final.tscn").instance()
	self.add_child(final_box)
	final_box.rect_global_position=Vector2(100,100)
	$FinalTimer.start()
	
func restart():
	finished=false
	score1 = 0
	$Score1.text= str(score1)
	score2 = 0
	$Score2.text= str(score2)
	$Timer.start()
	final_box.queue_free()
	
func _final_Timer_timeout():
	finished=true
	
func _process(delta):
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet().get_string_from_ascii()
		if packet:
			emit_signal("joystick",packet)
	
	if (finished and (Input.is_action_just_pressed("p1_left") or Input.is_action_just_pressed("p2_left") or Input.is_action_just_pressed("p1_right") or Input.is_action_just_pressed("p2_right"))):
		restart()
		
