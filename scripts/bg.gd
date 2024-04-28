extends ParallaxBackground

@export var scroll_speed = 15
@export var bg_texture: CompressedTexture2D = preload("res://assets/textures/bg/Blue.png")

@onready var sprite_2d = $ParallaxLayer/Sprite2D

func _ready():
	sprite_2d.texture = bg_texture
	
func _process(delta):
	sprite_2d.region_rect.position += delta * Vector2(scroll_speed, scroll_speed)
	
	if sprite_2d.region_rect.position >= Vector2(64, 64):
		sprite_2d.region_rect.position = Vector2.ZERO
