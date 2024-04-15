class_name SummonPlayer extends Node2D

#CUSTOM ANIMATIONS
enum SpriteAnimations {
	IDLE,
	TRUMPET,
} 

@onready var idle_sprites = [
	$SpriteIdle1,
	$SpriteIdle2,
]

@onready var trumpet_sprites = [
	$SpriteTrumpet1,
	$SpriteTrumpet2,
]
@onready var current_animation = SpriteAnimations.IDLE
@onready var current_sprite = idle_sprites[0]
#END OF -- CUSTOM ANIAMTIONS

@onready var trumpet_area := $TrumpetArea
#@onready var allow_draw := true
@onready var god_song := $GodSong
@onready var sprite_timer := $SpriteTimer

@onready var circle_timer := $CircleSprites/CircleTimer
@onready var circle_index := 0
@onready var circle_sprites = [
	$CircleSprites/Sprite1,
	$CircleSprites/Sprite2,
]

var placed := false
var t := 0.0

func _ready() -> void:
	#sprite.play(ANIM_IDLE)
	sprite_timer.start()
	circle_timer.start()
	
func place(new_global_pos) -> void:
	#allow_draw = false
	global_position = new_global_pos
	god_song.play()
	
	#Restart timer and anim
	current_sprite.hide()
	current_animation = SpriteAnimations.TRUMPET
	current_sprite = trumpet_sprites[0]
	current_sprite.show()
	sprite_timer.stop()
	sprite_timer.start()
	
	var tween = create_tween()
	
	tween.tween_property(%CircleSprites, "modulate", Color.TRANSPARENT, 0.5)
	placed = true
	
func return_reached_areas() -> Array:
	return trumpet_area.get_overlapping_areas()

#func _draw() -> void:
	#if allow_draw:
		#draw_circle(to_local(global_position), 256, Color("#bbaa265f"))

func _on_god_song_finished() -> void:
	god_song.play()

func _process(delta: float) -> void:
	if visible:
		t += delta
	
func _on_sprite_timer_timeout() -> void:
	var index := 0 
	var sprites_to_check: Array
	match current_animation:
		SpriteAnimations.IDLE: sprites_to_check = idle_sprites
		SpriteAnimations.TRUMPET: sprites_to_check = trumpet_sprites
		
	if sprites_to_check.size() == 0: #Just to be safe
		return
	
	index = sprites_to_check.find(current_sprite) + 1
	if index > sprites_to_check.size() - 1:
		index = 0
	
	current_sprite.hide() #Hide old
	current_sprite = sprites_to_check[index] #set new sprite
	current_sprite.show() #Show new


func _on_circle_timer_timeout() -> void:
	circle_sprites[circle_index].hide()
	
	circle_index += 1
	if circle_index > 1:
		circle_index = 0
	
	circle_sprites[circle_index].show()
