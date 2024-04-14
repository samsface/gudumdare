extends Node2D

var added = false
var speed := 1.0
var life := 10.0
func _process(delta: float) -> void:
	if added:
		speed += delta * 20.0
		global_position = global_position.move_toward(Game.game.worm_icon.global_position, delta * 100.0 * speed)
		if global_position.distance_to(Game.game.worm_icon.global_position) < 50.0:
			queue_free()
			Game.worms += 1
	else:
		life -= delta
		if life < 2.0:
			visible = fmod(life/ 0.1, 1.0) > 0.5
		if life <= 0.0:
			queue_free()
		if get_local_mouse_position().length() < 50.0 or get_parent().get_parent().won:
			added = true
			$AudioAdd.play()
			z_index += 10
			visible = true
