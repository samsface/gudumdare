class_name Unit
extends Node2D

var battle: Battle


@export var health := 10
@onready var max_health: float = health

@export var is_foe := false
@export var speed := 300.0
@export var attack_range := 100.0
@export var reload_duration := 0.5

var reload_t := 0.0

var closest_enemy: Unit
var distance_to_closest_enemy := 0.0

@export var weight := 1.0
@export var radius := 30.0

func _process(delta: float) -> void:
	process_movement(delta)
	%Healthbar.value = health / max_health

func process_movement(delta):
	get_closest_enemy()
	if closest_enemy:
		if distance_to_closest_enemy > attack_range:
			position = position.move_toward(closest_enemy.position, delta * speed)
		else:
			reload_t -= delta
			if reload_t <= 0:
				attack()
				reload_t += reload_duration

func attack():
	pass

func hit(damage):
	health -= 1
	if health <= 0:
		remove()

func get_closest_enemy():
	var enemies = battle.friends if is_foe else battle.foes
	closest_enemy = null
	var closest_distance := 999999.0
	for enemy in enemies:
		var distance = position.distance_squared_to(enemy.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	distance_to_closest_enemy = sqrt(closest_distance)

func remove():
	queue_free()
	if is_foe:
		battle.foes.erase(self)
	else:
		battle.friends.erase(self)
	battle.units.erase(self)
