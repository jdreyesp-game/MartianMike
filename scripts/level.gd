extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false

@onready var start = $Start
@onready var player = null
@onready var exit = $Exit
@onready var death_zone = $DeathZone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

var timer_node = null

@export var level_time = 5
var time_left = null
var win = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
		
	for trap in get_tree().get_nodes_in_group("traps"):
		trap.touched_player.connect(_on_trap_touched_player)
	
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_death_zone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "Level timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
		
func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset()
			hud.set_time_label(time_left)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
func _on_death_zone_body_entered(body):
	AudioPlayer.play_sfx("hurt")
	reset()

func _on_exit_body_entered(body):
	if body is Player and (is_final_level or next_level != null):
		exit.animate()
		player.active = false
		win = true
		await get_tree().create_timer(1.5).timeout
		if is_final_level:
			ui_layer.show_win_screen(true)
		else:
			get_tree().change_scene_to_packed(next_level)
	
func _on_trap_touched_player():
	AudioPlayer.play_sfx("hurt")
	reset()

func reset():
	time_left = level_time
	hud.set_time_label(time_left)
	reset_player()
	reset_traps()
	
func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	
func reset_traps():
	for trap in get_tree().get_nodes_in_group("traps"):
		var new_trap = load(trap.scene_file_path).instantiate()
		new_trap.global_position = trap.global_position
		new_trap.touched_player.connect(_on_trap_touched_player)
		trap.queue_free()
		add_child(new_trap)	
