class_name MinigameSummonWorms extends Node2D

@onready var player: SummonPlayer = $Player
@onready var worms_label := $HUD/WormsLabel

var worms := 0

static var current

func _ready() -> void:
	current = self
	player.set_allow_input(true)
	print("rng: " + str(RNG.random_int(1,5)))

func add_worm() -> void:
	worms += 1
	worms_label.text = "WORMS: " + str(worms)
