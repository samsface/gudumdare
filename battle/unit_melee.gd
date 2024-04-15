extends Unit

@export var damage := 1

func attack():
	$Model/AnimationPlayer.play("attack")
	$Model/AnimationPlayer.queue("walk")
	GenericTween.attack($Model, global_position.direction_to(closest_enemy.position))
	closest_enemy.hit(damage)
