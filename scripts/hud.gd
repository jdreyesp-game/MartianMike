extends Control

func set_lives_label(value):
	$NumLives.text = "LIVES: " + str(value)
	
func set_time_label(value):
	$TimeLabel.text = "TIME: " + str(value)
