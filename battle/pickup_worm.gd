extends Node2D

var added = false
var speed := 1.0
var life := 0.0
var velocity: Vector2
func _ready() -> void:
	scale = Vector2.ONE * 0.8
func _process(delta: float) -> void:
	if added:
		speed += delta * 20.0
		global_position = global_position.move_toward(Game.game.worm_icon.global_position, delta * 100.0 * speed)
		if global_position.distance_to(Game.game.worm_icon.global_position) < 50.0:
			queue_free()
			Game.worms += 1
	else:
		life += delta
		if life > 8.0:
			visible = fmod(life/ 0.1, 1.0) > 0.5
		if life > 10.0:
			queue_free()
		if life > 0.2 and get_local_mouse_position().length() < 100.0 or get_parent().get_parent().won:
			added = true
			GenericTween.squish(self)
			$AudioAdd.play()
			z_index += 10
			visible = true
		position += velocity * delta
		velocity -= velocity * delta * 5.0
