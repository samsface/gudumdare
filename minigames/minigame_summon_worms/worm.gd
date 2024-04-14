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

var since_dancing := 0.0
var dancing := false

func _ready() -> void:
	if RNG.random_int(0,1) == 1:
		for sprite in sprites:
			sprite.scale.x *= -1

func reveal() -> void:
	current_sprite.show()
	sprite_timer.start()
	dancing = true
	Game.worm_added = 0.0

func _on_sprite_timer_timeout() -> void:
	var index := 0 
	index = sprites.find(current_sprite) + 1
	if index > MAX_SPRITE:
		index = PRE_LAST_SPRITE 

	#print("old sprite: " + current_sprite.name)
	current_sprite.hide() #Hide old
	current_sprite = sprites[index] #set new sprite
	current_sprite.show() #Show new
	#print("new sprite: " + current_sprite.name)

func _process(delta: float) -> void:
	if dancing:
		since_dancing += delta
		if since_dancing > 0.7:
			if Game.worm_added > 0.15:
				modulate = Color(0.7, 0.7, 0.7)
				Game.worm_added = 0.0
				dancing = false
				Game.worms += 1
				%AudioAdd.play()
				%Point.visible = true
				await get_tree().create_timer(0.3).timeout
				%Point.visible = false
				
