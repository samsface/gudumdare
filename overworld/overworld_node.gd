@tool
extends Node2D

@export var neighbors: Array[Node2D] = []

@export var available := false

@export var is_altar := false

enum Type{BATTLE, BATTLE_PATH, MINI_1, MINI_2, MINI_3}

var completed := false

func _ready() -> void:
	if Engine.is_editor_hint():
		for neighbor in neighbors:
			if not neighbor.neighbors.has(self):
				neighbor.neighbors.push_back(self)
	%Name.text = name.capitalize()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	for neighbor in neighbors:
		draw_line(Vector2.ZERO, neighbor.position - position, Color.WHITE, 4.0)


func _on_area_brush_2d_mouse_clicked() -> void:
	Game.game.transition.set_circle_position(global_position)
	if is_altar:
		Game.game.open_altar()
		return
	Game.game.open_battle("res://battle/battles/%s.tscn" % name.to_snake_case())


func _on_area_brush_2d_mouse_entered() -> void:
	get_parent().set_title(name.capitalize())


func _on_area_brush_2d_mouse_exited() -> void:
	get_parent().set_title()
