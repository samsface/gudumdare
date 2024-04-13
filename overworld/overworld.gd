extends Node2D

func _ready() -> void:
	pass

func _on_button_button_down() -> void:
	Game.game.open_shop()
