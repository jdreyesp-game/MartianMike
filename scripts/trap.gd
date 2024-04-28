extends Node2D

signal touched_player

func _on_area_2d_body_entered(body):
	if body is Player:
		touched_player.emit() # Godot 4

func test():
	print("You called me")
