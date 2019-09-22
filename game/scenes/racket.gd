extends KinematicBody2D

var player := 1
var limit_left: int
var limit_right: int

var speed = 100

var new_position

var cadena = 0
var cantidad = 0#renombrar por otra cosa que sea más claro
var command_joystick
var state = 0

var lost_packets := 0

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
		
	update_state()
	
	if new_position != position.x:
		new_position = clamp(new_position, limit_left, limit_right)
		var movement = new_position - position.x
		move_and_collide(Vector2(movement, 0))
	


func _on_Game_joystick(value):
	if value != "continue":
		cadena = value.split("-")
		cantidad = float(cadena[1])
		command_joystick = cadena[0]
	
	elif lost_packets > 30: #Sube cada frame que no hay paquete, así que a los 30 frames (medio segundo) la raqueta se para.
		cantidad = 0
		lost_packets = 0
	else:
		lost_packets += 1  #La raqueta se queda igual pero subue el contador de paquete perdido.
#	if value.begins_with("Left-"):
#		sense= -1
#	else:
#		sense= +1

func update_state():
	if ((cantidad>0)):
		if(command_joystick =="Left"):
			state = -1
		elif(command_joystick == "Right"):
			state= 1
		else:
			state= 0
	else:
		state = 0
