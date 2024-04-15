extends UnitEffect

func effect(grade: float) -> void:
	for friend in battle.friends:
		if not is_instance_valid(friend):
			continue
		if global_position.distance_to(friend.global_position) < attack_range:
			friend.add_shield(ceil(grade * 3))
		
		await get_tree().create_timer(0.1).timeout
