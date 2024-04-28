extends Node2D

@onready var start_position = $StartPosition
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = start_position.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		


func _on_death_zone_body_entered(body):
	body.velocity = Vector2.ZERO
	body.global_position = start_position.global_position
