extends Unit

@export var damage := 1

func attack():
	$Model/AnimationPlayer.play("attack")
	$Model/AnimationPlayer.queue("walk")
	GenericTween.attack($Model, global_position.direction_to(closest_enemy.position))
	closest_enemy.heal()

func get_enemies():
	return battle.friends

func get_closest_enemy():
	var enemies = battle.friends
	closest_enemy = null
	var closest_distance := 999999.0
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		if not enemy.attackable:
			continue
		if enemy.name == "TowerPlayer":
			continue
		if enemy.health >= enemy.max_health:
			continue
		var distance = position.distance_squared_to(enemy.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	distance_to_closest_enemy = sqrt(closest_distance)
