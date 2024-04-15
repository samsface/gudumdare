extends UnitRanged

func attack():
	GenericTween.attack($Model, global_position.direction_to(closest_enemy.position))
	
	for i in 6:
		var projectile: Projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.position = position
		projectile.init(battle, closest_enemy, is_foe)
