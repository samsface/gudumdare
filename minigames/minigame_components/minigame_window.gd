extends CanvasLayer

signal minigame_ended(rating: float)

@onready var minigame_viewport = $MiniGameControl/SubViewportContainer/SubViewport
@onready var minigame_timer = $Timer

@onready var gameover_group = $MiniGameControl/SubViewportContainer/SubViewport/CanvasLayer/GameOver
@onready var gameover_group_won = $MiniGameControl/SubViewportContainer/SubViewport/CanvasLayer/GameOver/GameOverWon
@onready var gameover_group_lost = $MiniGameControl/SubViewportContainer/SubViewport/CanvasLayer/GameOver/GameOverLost

var minigame_scene: Node2D
var rating: float = 0

# if you want to test, uncomment the following lines
func _ready():
	pass
	#load_minigame("res://minigames/minigame_burn_the_wood/minigame_burn_the_wood.tscn")

# call this function to start the minigame.
func load_minigame(minigame: String):
	minigame_scene = load(minigame).instantiate()
	minigame_viewport.add_child(minigame_scene)
	
	%Prompt.text = "[jiggle amp=2 freq=5][center]%s[/center][/jiggle]" % minigame_scene.prompt.to_upper()
	# connect signals
	minigame_timer.minigame_timer_ended.connect(minigame_scene.timer_ended)
	minigame_timer.start_timer()
	
	minigame_scene.minigame_gameover_lost.connect(gameover_lost)
	minigame_scene.minigame_gameover_won.connect(gameover_won)

func gameover_lost():
	minigame_timer.stop_timer()
	gameover_group.show()
	gameover_group_lost.show()
	_on_ok_button_pressed()

func gameover_won(rating: float):
	self.rating = rating
	minigame_timer.stop_timer()
	gameover_group.show()
	gameover_group_won.show()
	_on_ok_button_pressed()

func _on_ok_button_pressed() -> void:
	$Score.visible = true
	# hack way to pause the mini game
	%SubViewport.render_target_update_mode = 0
	await get_tree().create_timer(0.5).timeout
	minigame_ended.emit(rating)
	queue_free()


var border_color_t := 0.0
func _process(delta: float) -> void:
	border_color_t += delta * 2.0
	%Border.modulate = lerp(Color.MAGENTA, Color.BLUE, pingpong(border_color_t, 1.0))
	
	%BackgroundRotator.rotation += sin(border_color_t * 0.5) * delta * 0.2
