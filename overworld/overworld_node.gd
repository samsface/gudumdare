@tool
extends Node2D

@export var neighbors: Array[Node2D] = []

@export var available := false

enum Type{BATTLE, BATTLE_PATH, MINI_1, MINI_2, MINI_3}

var completed := false

func _ready() -> void:
	if Engine.is_editor_hint():
		for neighbor in neighbors:
			if not neighbor.neighbors.has(self):
				neighbor.neighbors.push_back(self)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	for neighbor in neighbors:
		draw_line(Vector2.ZERO, neighbor.position - position, Color.WHITE, 4.0)


func _on_area_brush_2d_mouse_clicked() -> void:
	Game.game.open_battle("res://battle/battles/%s.tscn" % name.to_snake_case())
