extends Minigame

@export var turning_speed_time_max: float = 0.3
@export var turning_speed_time_min: float = 0.15
@export var guard_lookout_time: float = 1
@export var hero_speed = 600

@export var hero_x_offset = 120
@export var basket_y_lifted_offset = -80
@export var basket_y_offset = -35


@onready var bird_guard: Node2D = $Actors/Bird_Guard
@onready var hero: Node2D = $Actors/Hero
@onready var basket: Node2D = $Actors/Fruit_Basket

var wormWon: int = 0

var is_hero_moving: bool = false
var is_bird_looking_out: bool = false
var is_game_on = true

var started_turning_event: bool = false
var turning_event_speed: float = 1
var turning_event_phase: int = 0
var delta_count: float = 0

func _process(delta: float) -> void:
	if (!is_game_on):
		return
	process_hero(delta)
	process_guard(delta)
	
func process_hero(delta: float):
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		if(is_bird_looking_out):
			loose()
			return
		else:
			basket.position.y = basket_y_lifted_offset
			basket.position.x = hero.position.x + hero_x_offset
			is_hero_moving = true
			hero.position.x += delta * hero_speed
	else:
		basket.position.y = basket_y_offset
		is_hero_moving = false

func process_guard(delta: float):
	if (started_turning_event):
		delta_count += delta
		if (delta_count > turning_event_speed):
			advance_guard_phase()
			delta_count = 0
	else:
		turning_event_speed = randf_range(turning_speed_time_min, turning_speed_time_max)
		started_turning_event = true

func advance_guard_phase():
	match(turning_event_phase):
		0:
			$Effects/Question_Mark1.show()
		1:
			$Effects/Question_Mark2.show()
		2:
			$Effects/Question_Mark3.show()
		3:
			bird_guard.scale.x = -1
			is_bird_looking_out = true
		4:
			reset_bird_guard()
			return
	turning_event_phase += 1

func reset_bird_guard():
	turning_event_phase = 0
	delta_count = 0
	is_bird_looking_out = 0
	started_turning_event = false
	
	bird_guard.scale.x = 1
	$Effects/Question_Mark1.hide()
	$Effects/Question_Mark2.hide()
	$Effects/Question_Mark3.hide()

func loose():
	super.loose()
	is_game_on = false

func win(rating: float = 1.0):
	super.win(rating)
	is_game_on = false

func _on_hero_area_2d_area_entered(area: Area2D) -> void:
	win(wormWon)
