extends Node2D

const PRE_LAST_SPRITE = 4
const MAX_SPRITE = 5

@onready var sprites = [
	$Sprite1,
	$Sprite2,
	$Sprite3,
	$Sprite4,
	$Sprite5,
	$Sprite6,
]

@onready var current_sprite = sprites[0]
@onready var sprite_timer = $SpriteTimer

func _ready() -> void:
	if RNG.random_int(0,1) == 1:
		for sprite in sprites:
			sprite.scale.x *= -1

func reveal() -> void:
	current_sprite.show()
	sprite_timer.start()

func _on_sprite_timer_timeout() -> void:
	var index := 0 
	
	var previous_index = index
	index = sprites.find(current_sprite) + 1
	if index > MAX_SPRITE:
		index = PRE_LAST_SPRITE 

	current_sprite.hide() #Hide old
	current_sprite = sprites[index] #set new sprite
	current_sprite.show() #Show new
