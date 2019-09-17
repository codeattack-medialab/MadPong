extends KinematicBody2D

var player := 1
var limit_left: int
var limit_right: int

var speed = 100

func set_field_limits(field_left: int, field_right: int):
	var half_racket_length: int = $CollisionShape2D.shape.extents.x
	limit_left = field_left + half_racket_length + 1
	limit_right = field_right - half_racket_length - 1

func _physics_process(delta: float):
	var new_position := position.x

	if Input.is_action_pressed("p%d_left" % player):
		new_position -= speed * delta
	if Input.is_action_pressed("p%d_right" % player):
		new_position += speed * delta

	if new_position != position.x:
		new_position = clamp(new_position, limit_left, limit_right)
		var movement = new_position - position.x
		move_and_collide(Vector2(movement, 0))
