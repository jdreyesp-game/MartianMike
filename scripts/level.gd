extends Node2D

@export var next_level: PackedScene = null
@onready var start = $Start
@onready var player = null
@onready var exit = $Exit
@onready var death_zone = $DeathZone

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
		
	for trap in get_tree().get_nodes_in_group("traps"):
		trap.touched_player.connect(_on_trap_touched_player)
	
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_death_zone_body_entered)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
func _on_death_zone_body_entered(body):
	reset_player()

func _on_exit_body_entered(body):
	if body is Player and next_level != null:
		exit.animate()
		player.active = false
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_packed(next_level)
	
func _on_trap_touched_player():
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	for trap in get_tree().get_nodes_in_group("traps"):
		var new_trap = load(trap.scene_file_path).instantiate()
		new_trap.global_position = trap.global_position
		new_trap.touched_player.connect(_on_trap_touched_player)
		trap.queue_free()
		add_child(new_trap)
		
