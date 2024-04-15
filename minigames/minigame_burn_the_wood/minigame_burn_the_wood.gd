extends Minigame


const STICK = preload("res://minigames/minigame_burn_the_wood/stick.tscn")

@export var number_of_sticks := 6

var stick_count := 0
var selected_stick: Stick

@onready var flames = [
	$Fire/Flames/FlameStart,
	$Fire/Flames/FlameSmall,
	$Fire/Flames/FlameMedium,
	$Fire/Flames/FlameLarge
]




func _ready() -> void:
	var rotation_options = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180]
	
	var spawns = $SpawnPoints.get_children()
	spawns.shuffle()
	# Spawn the passed-in number of sticks that the player needs to burn
	for i in number_of_sticks:
		var stick: Stick = STICK.instantiate()
		add_child(stick)
	
		# Give the stick a random rotation
		stick.rotate(deg_to_rad(rotation_options.pick_random()))
		stick.position = spawns[i].position
	
	#hide_flames()
	$Fire/Flames/FlameStart.show()

var t := 0.0

func _process(delta: float) -> void:
	t += delta * (1.0 + stick_count * 0.2) * 2.0
	%Flames.scale = Vector2(
		1.0 + sin(floor(t * 6.0) / 6.0 * TAU) * 0.1,
		1.0 - sin(floor(t * 6.0) / 6.0 * TAU) * 0.1
	)

#func hide_flames():
	#for f in flames:
		#f.hide()


func _on_fire_area_entered(area: Area2D) -> void:
	
	area.queue_free()
	selected_stick = null

	stick_count += 1

	# No true "lose" condition, at least right now

	#hide_flames()
	
	%BrushAnimation2D.fps += 5
	
	var stick_percentage: float = stick_count as float / number_of_sticks as float
	score = stick_percentage

	#print(stick_percentage)
	if stick_count == number_of_sticks:#stick_percentage >= 0.8:
		$Fire/Flames/FlameLarge.show()
		%BrushAnimation2D.visible = false
		%Roasted.visible = true
		GenericTween.squish(%Roasted)
		$AudioMicrowave.play()
		$AudioHot.stop()
		
		await $AudioMicrowave.finished
		_finished()
	elif stick_count == 4:#stick_percentage >= 0.5:
		$Fire/Flames/FlameMedium.show()
	elif stick_count == 3:#stick_percentage >= 0.5:
		$AudioHot.stream = load("res://minigames/minigame_burn_the_wood/sfx/hot_2.wav")
		$AudioHot.play()
	elif stick_count == 2:#stick_percentage >= 0.5:
		$AudioHot.stream = load("res://minigames/minigame_burn_the_wood/sfx/hot_1.wav")
		$AudioHot.play()
	elif stick_count == 1:#stick_percentage >= 0.25:
		$Fire/Flames/FlameSmall.show()
		$AudioHot.stream = load("res://minigames/minigame_burn_the_wood/sfx/hot_0.wav")
		$AudioHot.play()
	$AudioHot.pitch_scale = 0.7 + stick_count * 0.15
	$AudioFire.play()
	$AudioFire.pitch_scale = 1.0 + stick_count * 0.2
	$AudioFire.volume_db = linear_to_db(0.5 + stick_count * 0.1)
