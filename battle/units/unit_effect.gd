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

	var grade = await minigame_window_scene.finished
	minigame_window_scene.queue_free()

	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "global_position", original_camera_position, 0.2)
	tween.tween_property(camera, "zoom", Vector2.ONE, 0.2)
	

	await tween.finished
	
	$AreaCircle.animate()
	
	prints("Grade was ", grade)
	
	effect(grade)
	
	
	
	
	#queue_free()
	
func effect(grade):
	pass

