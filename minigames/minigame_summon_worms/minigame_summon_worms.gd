extends Minigame

const WORM_OFFSET = 32

@onready var player: SummonPlayer = $Player
@onready var timer: Timer = $Timer
@onready var timer_running := true
@onready var total_worm_count := 0

var min_x: int
var max_x: int
var min_y: int
var max_y: int

func _ready() -> void:
	timer.start()

	min_x = $Origin.global_position.x + WORM_OFFSET
	max_x = $TopCornerRight.global_position.x - WORM_OFFSET
	min_y = $Origin.global_position.y + WORM_OFFSET
	max_y = $BotCornerLeft.global_position.y - WORM_OFFSET

func _physics_process(delta: float) -> void:
	if not timer_running:
		return
		
	var global_mouse_pos = get_global_mouse_position()
	player.global_position.x = clamp(global_mouse_pos.x, min_x, max_x)
	player.global_position.y = clamp(global_mouse_pos.y, min_y, max_y)
		
	if Input.is_action_just_pressed("LMB"):
		timer.stop()
		timer_running = false
		player.place(get_global_mouse_position())
		
		var reached_areas: Array = player.return_reached_areas()
		
		for area in reached_areas:
			area.reveal_worms()
			total_worm_count += area.worm_count
			
		win(total_worm_count)
			

func _on_timer_timeout() -> void:
	player.place(player.global_position) #Place player whereever he is right now
	timer_running = false
	win(0)
