extends Control

func _ready():
	AudioPlayer.start_music()

func start_game():
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	
func quit_game():
	get_tree().quit()


func _on_start_button_pressed():
	start_game()


func _on_quit_button_pressed():
	quit_game()
