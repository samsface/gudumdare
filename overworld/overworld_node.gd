@tool
extends Node2D

@export var neighbors: Array[Node2D] = []

@export var available := false

enum Type{BATTLE, BATTLE_PATH, MINI_1, MINI_2, MINI_3}

@export var type: Type
@export_file("*.tscn") var scene := ""

var completed := false

func _ready() -> void:
	if Engine.is_editor_hint():
		for neighbor in neighbors:
			if not neighbor.neighbors.has(self):
				neighbor.neighbors.push_back(self)
	match type:
		Type.MINI_1:
			$Sprite.modulate = Color.GREEN
		Type.MINI_2:
			$Sprite.modulate = Color.BLUE
		Type.MINI_3:
			$Sprite.modulate = Color.RED
		Type.BATTLE_PATH:
			$Sprite.modulate = Color.GRAY

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	for neighbor in neighbors:
		draw_line(Vector2.ZERO, neighbor.position - position, Color.WHITE, 4.0)


func _on_area_brush_2d_mouse_clicked() -> void:
	match type:
		Type.BATTLE, Type.BATTLE_PATH:
			Game.game.open_battle(scene)
		Type.MINI_1, Type.MINI_2, Type.MINI_3:
			Game.game.open_minigame(scene)
			Game.game.transition.set_circle_position(global_position)
