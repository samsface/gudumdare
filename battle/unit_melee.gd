extends Unit

@export var damage := 1

func attack():
	closest_enemy.hit(damage)
