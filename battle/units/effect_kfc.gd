extends UnitEffect

func effect(grade:float) -> void:
	var friends = battle.friends
	for friend in battle.friends:
		friend.boost_speed(3.0, 3.0 * grade)
		friend.boost_reload(2.0, 3.0 * grade)
	#var foes = battle.foes.duplicate()
	#
	#attack_range = 400.0 * grade
	#%Slash.visible = true
	#for foe in foes:
		#if not is_instance_valid(foe):
			#continue
		#if global_position.distance_to(foe.global_position) < attack_range:
			#foe.hit(16.0)
			#$HitSound.play()
			#%Slash.global_position = foe.global_position
			#%Slash.rotation = randf() * PI
			#GenericTween.squish(%Slash)
			#await get_tree().create_timer(0.1).timeout
	remove()
