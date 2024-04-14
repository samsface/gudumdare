extends Unit
class_name UnitEffect

@export var mini_game:PackedScene

func _ready() -> void:
	set_process(false)
	
	Game.game.duck_music(true)
	var original_camera_position = get_viewport().get_camera_2d().global_position
	
	var camera = get_viewport().get_camera_2d()
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "global_position", global_position, 0.3)
	tween.tween_property(camera, "zoom", Vector2(2.0, 2.0), 0.3)
	
	await tween.finished
	
	battle.units.erase(self)

	var minigame_window_scene := preload("res://minigames/minigame_components/minigame_window_scene.tscn").instantiate()
	add_child(minigame_window_scene)
	minigame_window_scene.load_minigame(mini_game.resource_path)

	var grade = await minigame_window_scene.minigame_ended
	minigame_window_scene.queue_free()

	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "global_position", original_camera_position, 0.2)
	tween.tween_property(camera, "zoom", Vector2.ONE, 0.2)
	
	#tween.tween_property(card, "position:z", 0.5, 0.2).set_delay(0.1)
	tween.tween_property($Explosion, "emitting", true, 0.00).set_delay(0.2)
	tween.tween_property(card, "scale", Vector3.ZERO, 0.00).set_delay(0.2)

	await tween.finished
	
	$AreaCircle.animate()
	
	card.queue_free()
	
	effect(grade)
	
	await $Explosion.finished
	
	
	
	#queue_free()
	

func effect(grade:float) -> void:
	var foes = battle.foes.duplicate()
	
	for foe in foes:
		if not is_instance_valid(foe):
			continue
		if global_position.distance_to(foe.global_position) < attack_range:
			foe.hit(grade * 10.0)
			$HitSound.play()
		
		await get_tree().create_timer(0.1).timeout
