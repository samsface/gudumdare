extends Projectile

func init(battle: Battle, target: Unit, is_foe: bool):
	self.battle = battle
	velocity = position.direction_to(target.position) * 1000.0
	%Model.rotation = velocity.angle()
