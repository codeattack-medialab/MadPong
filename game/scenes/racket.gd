extends KinematicBody2D

var player := 1
var limit_left: int
var limit_right: int

var speed = 100

var new_position

var sense = 0

func set_field_limits(field_left: int, field_right: int):
	var half_racket_length: int = $CollisionShape2D.shape.extents.x
	limit_left = field_left + half_racket_length + 1
	limit_right = field_right - half_racket_length - 1

func _physics_process(delta: float):
	new_position = position.x
	if Input.is_action_pressed("p%d_left" % player):
		new_position -= speed * delta
	if Input.is_action_pressed("p%d_right" % player):
		new_position += speed * delta
	if sense != 0:
		new_position  += speed *speed * delta
	if new_position != position.x:
		new_position = clamp(new_position, limit_left, limit_right)
		var movement = new_position - position.x
		move_and_collide(Vector2(movement, 0))
		sense = 0


func _on_Game_joystick(value):
	if value.begins_with("Left-"):
		sense= -1
	else:
		sense= +1