extends Minigame

@onready var sword: Button = $Actors/Sword
@onready var birdList: Node2D = $Actors/BirdList
@onready var hero: AnimatedSprite2D = $Actors/Hero/AnimatedSprite2D

var birds_destroyed = 0
var birds_max = 0
var rating: float = 0.0

@onready var death_index := 0
@onready var death_sounds: Array = [$Death1, $Death2, $Death3, $Death4, $Death5]

# Called when the node enters the scene tree for the first time.
func _ready():
	death_sounds.shuffle()
	
	sword.samurai_ready.connect(samurai_is_ready)
	sword.samurai_attacked.connect(samurai_attack)
	birds_max = birdList.get_child_count()
	hero.play("Ready")

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
	
	death_sounds[death_index].play()
	death_index += 1
	
	if (birds_destroyed >= birds_max):
		win(rating)
	%AudioSlash.play()
	shake()

func find_next_available_bird():
	for bird in birdList.get_children():
		if (!bird.is_dead):
			return bird
	return null
