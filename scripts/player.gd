extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var speed = 125
@export var jump_force = 200
@export var num_lives = 3

@onready var animated_sprite_2d = $AnimatedSprite2D2

var active = true


func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
	
	var direction = 0
	
	if active:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump(jump_force)
		
		direction = Input.get_axis("move_left", "move_right")
		if direction != 0:
			animated_sprite_2d.flip_h = (direction == -1)
			
		velocity.x = direction * speed
		
		move_and_slide()
		
	update_animations(direction)	
	
func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force

func update_animations(direction: int):
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")	

func die():
	num_lives -= 1
