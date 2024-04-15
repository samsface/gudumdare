extends Projectile

func init(battle: Battle, target: Unit, is_foe: bool):
	self.battle = battle
	velocity = position.direction_to(target.position).rotated(randf_range(-1, 1) * 0.5) * 1000.0
	%Model.rotation = velocity.angle()
