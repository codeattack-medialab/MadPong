extends KinematicBody2D

var player := 1
var limit_left: int
var limit_right: int

var speed = 100

var new_position

#var cadena = 0
#var cantidad = 0#renombrar por otra cosa que sea más claro
#var command_joystick
var state = 0

#var lost_packets := 0
var stop_movement := false

func set_field_limits(field_left: int, field_right: int):
	var half_racket_length: int = $CollisionShape2D.shape.extents.x
	limit_left = field_left + half_racket_length + 1
	limit_right = field_right - half_racket_length - 1

func _physics_process(delta: float):
	new_position = position.x
	new_position += state * speed * delta
	if Input.is_action_pressed("p%d_left" % player):
		new_position -= speed * delta
	if Input.is_action_pressed("p%d_right" % player):
		new_position += speed * delta
		
#	update_state()
	
	if new_position != position.x:
		new_position = clamp(new_position, limit_left, limit_right)
		var movement = new_position - position.x
# warning-ignore:return_value_discarded
		move_and_collide(Vector2(movement, 0))
	


func _on_Game_joystick(value):
	if value != "continue":
		state = float(value)
		$Timer.stop()
		$Timer.start()
	elif stop_movement:
		state = 0
		stop_movement = false

#func update_state():
#	if ((cantidad>0)):
#		if(command_joystick =="Left"):
#			state = -1
#		elif(command_joystick == "Right"):
#			state= 1
#		else:
#			state= 0
#	else:
#		state = 0


func _on_Timer_timeout():
	stop_movement= true
