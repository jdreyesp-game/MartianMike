extends Node2D

signal touched_player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body is Player:
		touched_player.emit() # Godot 4

