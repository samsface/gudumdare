class_name Projectile
extends Node2D

@export var damage := 1
@export var life_time := 1.0

var battle: Battle
var velocity := Vector2()
var is_foe := false

var t := 0.0

func init(battle: Battle, target: Unit, is_foe: bool):
	self.battle = battle
	self.is_foe = is_foe
	velocity = position.direction_to(target.position) * 1000.0
	%Model.rotation = velocity.angle()

func _process(delta: float) -> void:
	var range_squared := 20.0 ** 2
	position += velocity * delta
	
	var enemies = battle.friends if is_foe else battle.foes
	var closest_distance := 999999.0
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var distance = position.distance_squared_to(enemy.position)
		if distance < range_squared:
			queue_free()
			enemy.hit(damage)
	t += delta
	if t > life_time:
		queue_free()
