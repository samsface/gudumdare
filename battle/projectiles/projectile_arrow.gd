extends Projectile

@export var speed := 1000.0

func init(battle: Battle, target: Unit, is_foe: bool):
	self.battle = battle
	self.is_foe = is_foe
	velocity = position.direction_to(target.position) * speed
	
	%Model.rotation = velocity.angle()
