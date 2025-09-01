extends CharacterBody2D

const SPEED = 300
var direction_x: int = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var time_against_wall = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = SPEED * direction_x

	if not is_zero_approx(velocity.x):
		animated_sprite_2d.flip_h = velocity.x < 0.0

	move_and_slide()
	
	if is_on_wall():
		time_against_wall += delta
		if(time_against_wall > 0.2):
			direction_x *= -1
			time_against_wall = 0
