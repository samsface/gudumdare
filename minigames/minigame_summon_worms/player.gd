class_name SummonPlayer extends CharacterBody2D

const ANIM_WALK = "walk"
const ANIM_TRUMPET = "trumpet"

const SPEED = 225

enum States {
	IDLE,
	WALK,
	TRUMPET,
}

@onready var sprite := $AnimatedSprite2D
@onready var trumpet_timer := $TrumpetTimer
@onready var allow_input := false
@onready var state := States.IDLE

func _ready():
	sprite.play(ANIM_WALK)
	
func set_allow_input(value: bool) -> void:
	allow_input = value

func _physics_process(delta: float) -> void:
	if not allow_input:
		return
		
	if state == States.IDLE or state == States.WALK:
		if Input.is_action_pressed("LMB"):
			sprite.play(ANIM_TRUMPET)
			state = States.TRUMPET
			trumpet_timer.start()
			return
			
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			direction.normalized()
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
			
		move_and_slide()
	
	elif state == States.TRUMPET:
		if not Input.is_action_pressed("LMB"):
			sprite.play(ANIM_WALK)
			state = States.IDLE
			trumpet_timer.stop()

func _on_trumpet_timer_timeout() -> void:
	MinigameSummonWorms.current.add_worm()
