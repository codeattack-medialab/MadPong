extends Node2D

export(String, "No", "FullScreen", "Window") var medialab_facade := "No"
export var max_score:= 3
var score1 := 0
var score2 := 0
var finished := false

var final_box

var udp
var splitted_packet_by_id


signal joystick1 #eñal que envía a las raquetas el valo
signal joystick2

func _enter_tree():
	var window_offset := Vector2(40, 40)
	if medialab_facade == "FullScreen" or medialab_facade == "Window":
		var screen_size := OS.get_screen_size()
		if screen_size == Vector2(1280, 1024):
			window_offset = Vector2(163, 142)

	if medialab_facade == "FullScreen":
		var viewport_size = Vector2(192+40, 157+40)
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_KEEP, viewport_size, 1)
		position = window_offset
		OS.window_fullscreen = true
	elif medialab_facade == "Window":
		OS.window_position = window_offset
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
	var err = udp.listen(33333, "0.0.0.0")
	if err != OK:
		print("error al conectarse al puerto 33333")
	else:
		print("Conectado satisfactoriamente")
		
		
	

func _on_body_entered(body,extra_arg_0):
	$Ball.set_physics_process(false)
	match extra_arg_0:
		1:
			score1+=1
			$Score1.text= str(score1)
		2:
			score2+=1
			$Score2.text= str(score2)
	if $Ball.speed > 120:
		$GoalParticles.position = $Ball.position
		$GoalParticles.emitting = true
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
	final_box.set_position(Vector2(95,92))
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
	if udp.get_available_packet_count() == 0:
		emit_signal("joystick1","continue")
		emit_signal("joystick2","continue")
		
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet().get_string_from_ascii()
		if packet:
#			print(packet)
			splitted_packet_by_id=packet.split("/")
			print("tipo",splitted_packet_by_id[1])
			print("valor:",splitted_packet_by_id[2])
			
			if (splitted_packet_by_id[1] == "X"):
				match(splitted_packet_by_id[0]): #Esto igual se puede hacer interpolando el string emit_signal(emit_signal("joystick%s" % splitted_packet_by_id[0] ,splitted_packet_by_id[2]) en vez del match, para una cantidad arbitraria de mandoos (no sé si es %s, debería de mirarlo)
					"1":
						emit_signal("joystick1",splitted_packet_by_id[2])
					"2":
						emit_signal("joystick2",splitted_packet_by_id[2])
			elif((splitted_packet_by_id[1] == "Click") and (finished) and (splitted_packet_by_id[2] == "1.0" or splitted_packet_by_id[2] == "2.0")):
				restart()
#		else:
#			emit_signal("joystick1","continue")
#			emit_signal("joystick2","continue")
	
	if (finished and (Input.is_action_just_pressed("p1_left") or Input.is_action_just_pressed("p2_left") or Input.is_action_just_pressed("p1_right") or Input.is_action_just_pressed("p2_right"))):
		restart()
	