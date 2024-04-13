extends Unit

func _ready() -> void:
	set_process(false)
	
	var original_camera_position = get_viewport().get_camera_2d().global_position
	
	var camera = get_viewport().get_camera_2d()
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "global_position", global_position, 0.2)
	tween.tween_property(camera, "zoom", Vector2(2.0, 2.0), 0.2)

	await tween.finished
	
	battle.units.erase(self)


	var minigame := preload("res://minigames/minigame_components/minigame_window_scene.tscn").instantiate()
	add_child(minigame)
	minigame.load_minigame("res://minigames/minigame_spike_the_birds/minigame_spike_the_birds.tscn")

	await minigame.minigame_ended
	minigame.queue_free()

	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "global_position", original_camera_position, 0.2)
	tween.tween_property(camera, "zoom", Vector2.ONE, 0.2)
	
	#tween.tween_property(card, "position:z", 0.5, 0.2).set_delay(0.1)
	tween.tween_property($Explosion, "emitting", true, 0.00).set_delay(0.2)
	tween.tween_property(card, "scale", Vector3.ZERO, 0.00).set_delay(0.2)

	await tween.finished
	
	card.queue_free()
	
	await $Explosion.finished
	
	queue_free()
	
	
