class_name SummonPlayer extends Node2D

const ANIM_IDLE = "idle"
const ANIM_TRUMPET = "trumpet"

@onready var sprite := $AnimatedSprite2D
@onready var trumpet_area := $TrumpetArea
@onready var allow_draw := true
@onready var god_song = $GodSong

func _ready():
	sprite.play(ANIM_IDLE)
	god_song.play()
	
func place(new_global_pos):
	allow_draw = false
	global_position = new_global_pos
	sprite.play(ANIM_TRUMPET)
	
func return_reached_areas() -> Array:
	return trumpet_area.get_overlapping_areas()

func _draw():
	if allow_draw:
		draw_circle(to_local(global_position), 128, Color("#bbaa265f"))

func _on_god_song_finished() -> void:
	god_song.play()
