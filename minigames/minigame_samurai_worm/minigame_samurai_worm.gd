extends Minigame

@onready var sword: Area2D = $Actors/Sword
@onready var birdList: Node2D = $Actors/BirdList
@onready var hero: AnimatedSprite2D = $Actors/Hero/AnimatedSprite2D

var birds_destroyed = 0
var birds_max = 0
var rating: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sword.samurai_ready.connect(samurai_is_ready)
	sword.samurai_attacked.connect(samurai_attack)
	birds_max = birdList.get_child_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func samurai_is_ready():
	hero.play("Ready")

func samurai_attack():
	hero.play("Idle")
	var bird = find_next_available_bird()
	if (bird == null):
		win(rating)
		return
	bird.die()
	birds_destroyed += 1
	rating = birds_destroyed / birds_max
	if (birds_destroyed >= birds_max):
		win(rating)

func find_next_available_bird():
	for bird in birdList.get_children():
		if (!bird.is_dead):
			return bird
	return null
