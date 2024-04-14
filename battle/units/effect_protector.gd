extends UnitEffect

func effect(grade:float) -> void:
	var friends = battle.friends.duplicate()
	
	for friend in friends:
		if not is_instance_valid(friend):
			continue
		if global_position.distance_to(friend.global_position) < attack_range:
			friend.heal_to_max()
		
		await get_tree().create_timer(0.1).timeout
