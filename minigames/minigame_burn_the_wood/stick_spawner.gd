extends Node2D


const STICK = preload("res://minigames/minigame_burn_the_wood/stick.tscn")

var sticks = []


func spawn(spawn_points: Array) -> Array:
	var rotation_options = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180]

	# Spawn 10 sticks the player needs to burn
	for i in 10:
		var s: Stick = STICK.instantiate()
		add_child(s)

		# Give the stick a random rotation
		s.rotate(deg_to_rad(rotation_options.pick_random()))
		s.position = spawn_points[i].position

		sticks.append(s)

	return sticks

