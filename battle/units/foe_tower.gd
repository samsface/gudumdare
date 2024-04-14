extends Node2D

@onready var battle: Battle = get_parent().get_parent()

var spawn_t := 3.0

func _process(delta: float) -> void:
	if battle.won:
		return
	spawn_t -= delta
	if spawn_t <= 0.0:
		var unit = load("res://battle/units/unit_foe_cop.tscn").instantiate()
		battle.add_unit(unit, position)
		spawn_t = randf_range(2.0, 3.0)
