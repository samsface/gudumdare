extends Node2D

func _ready() -> void:
	%CountGold.text = str(Game.game.gold)
	%CountSouls.text = str(Game.game.souls)
	%CountWorms.text = str(Game.game.worms)

func _on_button_button_down() -> void:
	Game.game.open_shop()
