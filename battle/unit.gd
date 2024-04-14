class_name Unit
extends Node2D

signal died

var battle: Battle
var card

@export var health := 10
@onready var max_health: float

@export var is_foe := false
@export var speed := 300.0
@export var attack_range := 100.0
@export var reload_duration := 0.5
@export var attackable := true

var reload_t := 0.0

var closest_enemy: Unit
var distance_to_closest_enemy := 0.0

@export var weight := 1.0
@export var radius := 30.0

var reload_boost_t := 0.0
var reload_boost_multi := 1.0

var speed_boost_t := 0.0
var speed_boost_multi := 1.0

var damage_tween:Tween
var shake_tween:Tween
@export var spawn_sound := 0

func _ready() -> void:
	if spawn_sound != 0:
		$AudioSpawn.stream = load("res://battle/units/sfx/anime_teleport_%s.wav" % spawn_sound)
		#$AudioSpawn.pitch_scale = randf_range(0.9, 1.1)
		$AudioSpawn.play()
	$AudioSpawn2.pitch_scale = randf_range(0.7, 0.8) if is_foe else randf_range(1.1, 1.3) 
	$AudioSpawn2.play()
	max_health = health

func _process(delta: float) -> void:
	process_movement(delta)
	%Healthbar2.value = health / max_health
	%Healthbar.value = move_toward(%Healthbar.value, %Healthbar2.value, delta / 1.0)
	
	if speed_boost_t > 0:
		speed_boost_t -= delta
		if speed_boost_t <= 0:
			speed_boost_multi = 1.0
	if reload_boost_t > 0:
		reload_boost_t -= delta
		if reload_boost_t <= 0:
			reload_boost_multi = 1.0

func process_movement(delta):
	if health <= 0:
		return

	get_closest_enemy()
	if closest_enemy:
		if distance_to_closest_enemy > attack_range:
			position = position.move_toward(closest_enemy.position, delta * speed * speed_boost_multi)
		else:
			reload_t -= delta * reload_boost_multi
			if reload_t <= 0:
				attack()
				$AudioAttack.play()
				reload_t += reload_duration

func attack():
	pass

func hit(damage):
	if health <= 0:
		return

	health -= damage
	if health <= 0:
		remove()
		if is_foe:
			Game.worms += 1
		died.emit()
		
		$Model/AnimationPlayer.play("RESET")
		$Model/AnimationPlayer.stop()
		if shake_tween:
			shake_tween.kill()
		if damage_tween:
			damage_tween.kill()
		damage_tween = GenericTween.flash(%Model, Color(10.0, 4.0, 4.0), Color(2.0, 0.5, 0.5), Color(0.1, 0.1, 0.1, 1.0))
		damage_tween.set_parallel()
		damage_tween.tween_property(%Model, "rotation", PI * 0.5, 0.1)
		damage_tween.tween_property(%Model, "scale", Vector2.ZERO, 0.1).set_delay(0.4)
	else:
		if shake_tween:
			shake_tween.kill()
		shake_tween = GenericTween.shake(%Model, 2, 2.0)
		if damage_tween:
			damage_tween.kill()
		damage_tween = GenericTween.flash_red(%Model)
	
	$AudioHit.play()

func get_closest_enemy():
	var enemies = battle.friends if is_foe else battle.foes
	closest_enemy = null
	var closest_distance := 999999.0
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		if not enemy.attackable:
			continue
		var distance = position.distance_squared_to(enemy.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	distance_to_closest_enemy = sqrt(closest_distance)

func remove():
	if is_foe:
		battle.foes.erase(self)
	else:
		battle.friends.erase(self)
	battle.units.erase(self)

	await get_tree().create_timer(0.5).timeout
	
	queue_free()


func boost_reload(scale: float, duration: float):
	reload_boost_t = duration
	reload_boost_multi = scale

func boost_speed(scale: float, duration: float):
	speed_boost_t = duration
	speed_boost_multi = scale
