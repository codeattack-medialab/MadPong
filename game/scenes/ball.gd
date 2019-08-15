extends KinematicBody2D

var speed := 20
var velocity := Vector2()

var limit_right := 0
var limit_left := 0

func _ready():
	start()

func start():
	#velocity = Vector2(speed, 0).rotated(rand_range(-PI, PI))
	velocity = Vector2(0, -speed)

func _physics_process(delta: float):
	if velocity.length() < 0.1:
		return

	var collision := move_and_collide(velocity * delta)
	if collision:
		print ("Collision with ", collision.collider_id)
