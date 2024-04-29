extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	pass
	#animate()
	
func animate():
	animated_sprite_2d.play("default")
