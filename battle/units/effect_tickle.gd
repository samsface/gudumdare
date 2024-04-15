extends UnitEffect

func effect(grade:float) -> void:
	var foes = battle.foes
	for foe in foes:
		#if global_position.distance_to(foe.global_position) < attack_range:
		foe.boost_speed(0.1, 8.0 * grade)
		foe.boost_reload(0.5, 8.0 * grade)
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
