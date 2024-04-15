extends Node2D

@onready var battle: Battle = get_parent().get_parent()

var spawn_t := 3.0

@export var spawn_delay := 5.0

@export var spawn_types := ["res://battle/units/unit_foe_cop.tscn"]

func _process(delta: float) -> void:
	delta *= Game.game_speed
	if battle.won:
		return
	spawn_t -= delta
	if spawn_t <= 0.0:
		var unit = load(spawn_types.pick_random()).instantiate()
		battle.add_unit(unit, position)
		spawn_t = spawn_delay * randf_range(0.8, 1.2)
