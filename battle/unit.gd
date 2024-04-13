class_name Unit
extends Node2D

var battle: Battle

var is_foe := false

var speed := 100.0

var closest_enemy: Unit

func _process(delta: float) -> void:
	if closest_enemy:
		position = position.move_toward(closest_enemy.position, delta * speed)


func get_closest_enemy():
	var enemies = battle.friends if is_foe else battle.foes
	closest_enemy = null
	var closest_distance := 999999.0
	for enemy in enemies:
		var distance = position.distance_squared_to(enemy.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
