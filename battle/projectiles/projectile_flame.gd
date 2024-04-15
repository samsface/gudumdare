extends Projectile

var hit_t := 0.0

var rotation_speed = randf_range(-1, 1)

func init(battle: Battle, target: Unit, is_foe: bool):
	self.battle = battle
	velocity = position.direction_to(target.position).rotated(randf_range(-1, 1) * 0.2) * 200.0
	%Model.rotation = randf() * TAU

func _process(delta: float) -> void:
	hit_t -= delta
	position += velocity * delta
	%Model.rotation += rotation_speed * delta
	if hit_t <= 0.0:
		hit_t += 0.2
		
		var range_squared := 20.0 ** 2
		
		var enemies = battle.friends if is_foe else battle.foes
		var closest_distance := 999999.0
		for enemy in enemies:
			if not is_instance_valid(enemy):
				continue
			var distance = position.distance_squared_to(enemy.position)
			if distance < range_squared:
				enemy.hit(damage)
	
	t += delta
	if t > life_time:
		queue_free()
