extends Control

signal minigame_timer_ended

@export var timer_seconds_value: float = 2.0

@onready var worm_timer_group: Control = $TimerWormArt
@onready var worm_timer_body: Sprite2D = $TimerWormArt/WormBody
@onready var worm_timer_head: AnimatedSprite2D = $TimerWormArt/WormHead
@onready var bird_animated_sprite: AnimatedSprite2D = $Bird

# Timer logic
var worm_timer_start_position: Vector2 = Vector2.ZERO
var worm_timer_end_position: Vector2 = Vector2.ZERO
var timer_delta_count: float = 0

var timer_started = false
var timer_ended = false

# Animation triggers
var afraid_animation_player = false

var wave_t := 0.0
var wave_speed := 0.0

func _process(delta: float) -> void:
	if (!timer_ended && timer_started):
		run_timer(delta)
	
	wave_speed += delta
	position.y = 655 + sin(wave_t * TAU) * 6.0 * wave_speed / 3.0
	wave_t += delta * wave_speed * 2.0

func start_timer():
	worm_timer_start_position = worm_timer_group.position
	worm_timer_end_position = worm_timer_start_position
	worm_timer_end_position.x += worm_timer_body.get_rect().size.x + 35
	timer_started = true

func stop_timer():
	timer_ended = true

func run_timer(delta: float):
	timer_delta_count += delta
	
	# Interpolate movement
	var interpolationValue = clamp(timer_delta_count / timer_seconds_value, 0.0, 1.0)
	
	# Interpolate position using linear interpolation
	var newPosition = worm_timer_start_position.lerp(worm_timer_end_position, interpolationValue)
	worm_timer_group.set_position(newPosition)
	
	if (!afraid_animation_player && timer_delta_count >= timer_seconds_value / 2):
		worm_timer_head.play("Afraid")
		afraid_animation_player = true
	
	# Check if movement is complete
	if timer_delta_count >= timer_seconds_value:
		end_timer()
		pass

func end_timer():
	bird_animated_sprite.play("EatingWorm")
	worm_timer_head.hide()
	timer_ended = true
	minigame_timer_ended.emit()
