extends KinematicBody2D

var speed := 40
var direction := Vector2()

var limit_right := 0
var limit_left := 0

func _ready():
	start()

func start():
	direction = Vector2.DOWN.rotated(rand_range(-PI/3, PI/3))

func _physics_process(delta: float):
	var velocity: Vector2 = direction * speed

	var collision := move_and_collide(velocity * delta)
	if collision:
		if collision.collider.name.begins_with("Racket"):
			direction = direction.bounce(Vector2.DOWN)
			direction.x = 0
			direction = direction.rotated(rand_range(-PI/3, PI/3)).normalized()
		elif collision.collider.name.begins_with("Wall"):
			direction = direction.bounce(Vector2.RIGHT)
