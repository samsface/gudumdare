extends Minigame


const BIRD = preload("res://minigames/minigame_spike_the_birds/bird.tscn")

@export var total_birds := 30
var birds_spawned := 0

var birds_spiked := 0
var birds_missed := 0

@onready var shield = $Shield
@onready var worm = $Worm
@onready var timer = $BirdTimer
@onready var bird_spawns = $BirdSpawns.get_children()

@onready var spiked_label = %SpikedValue
@onready var missed_label = %MissedValue

func _ready() -> void:
	# Replace 8.0 here with the time limit for the minigame
	var bird_spawn_rate: float = 8.0 / total_birds as float
	timer.wait_time = bird_spawn_rate
	timer.start()
	# initial wave just so we don't waste a second for the first timeout
	_on_bird_timer_timeout()


func spawn_bird():
	var spawn_location = bird_spawns.pick_random()
	var b = BIRD.instantiate()
	add_child(b)
	b.global_position = spawn_location.global_position
	b.spawn(worm.global_position)
	$AudioSpawn.pitch_scale = randf_range(0.9, 1.1)
	$AudioSpawn.play()


func _physics_process(delta: float) -> void:
	shield.rotation = (get_global_mouse_position() - shield.global_position).normalized().angle()


func check_if_minigame_over():
	# Game is over when every bird has been either spiked or missed.
	if birds_missed + birds_spiked == total_birds:
		minigame_over()


func timer_ended():
	minigame_over()

func minigame_over():
	printt(birds_spiked, total_birds)
	_finished()


func _on_worm_area_entered(area: Area2D) -> void:
	if area == shield:
		return
	elif "is_dead" in area and not area.is_dead:
		area.is_dead = true
		birds_missed += 1
		missed_label.text = str(birds_missed)
		area.queue_free()
		check_if_minigame_over()
		$Worm/WormAnimationPlayer.play("damage")
		$AudioHurt.pitch_scale = randf_range(1.5, 1.6)
		$AudioHurt.play()


func _on_bird_timer_timeout() -> void:
	if birds_spawned == total_birds:
		timer.stop()
	else:
		spawn_bird()
		birds_spawned += 1


func _on_shield_area_entered(area: Area2D) -> void:
	# Just making sure that we 1) collided with a bird and not another area, and
	# 2) this bird isn't already dead
	if "is_dead" in area and not area.is_dead:
		area.is_dead = true
		birds_spiked += 1
		spiked_label.text = str(birds_spiked)
		
		Game.give_worm(area.global_position)
		$Shield/ShieldSplat.play()
		area.play_particles()
		check_if_minigame_over()
		$AudioSpike.pitch_scale = randf_range(0.9, 1.1)
		$AudioSpike.play()

		score = birds_spiked * 0.2
