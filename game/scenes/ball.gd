extends KinematicBody2D

var speed := 50
var direction := Vector2()

var limit_right := 0
var limit_left := 0

var relative_pos : Vector2
var racket_size : float

var angle : float
var change_angle

var initial_pos := Vector2(96,94)

func _ready():
	start()

func start():
	direction = Vector2.DOWN.rotated(rand_range(-PI/3, PI/3))

func _physics_process(delta: float):
	var velocity: Vector2 = direction * speed
	var collision := move_and_collide(velocity * delta)
	if collision:
		if ((collision.collider.name.begins_with("Racket")) and (collision.normal.x == 0)):  #Para que no colisione con los laterales de la raqueta y se buguee
			relative_pos = collision.position - collision.collider.global_position
			racket_size = collision.collider.get_node("CollisionShape2D").shape.extents.x
			relative_pos.x += racket_size/2#suma la mitad del ancho para poder sacar la proporción al dividir
			direction = direction.bounce(Vector2.DOWN)
			direction.x = 0 
			angle=lerp(-PI/6, PI/6,relative_pos.x/racket_size)
			change_angle = 1 if collision.collider.name.ends_with("2") else -1
			direction = direction.rotated(change_angle*angle).normalized()
		elif ((collision.collider.name.begins_with("Racket")) and (collision.normal.x != 0)):  
			pass
		elif collision.collider.name.begins_with("Wall"):
			direction = direction.bounce(Vector2.RIGHT)



func _on_Timer_timeout():
	set_physics_process(true)


func _on_body_entered(body, extra_arg_0):
	set_physics_process(false)
	match extra_arg_0:
		1:
			$"/root/Game".score1+=1
			$"/root/Game/Score1".text= str($"/root/Game".score1)
		2:
			$"/root/Game".score2+=1
			$"/root/Game/Score2".text= str($"/root/Game".score2)
	position = initial_pos
	$"/root/Game/Timer".start()
