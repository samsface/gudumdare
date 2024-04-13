class_name Minigame
extends Node2D


func _ready() -> void:
	%CompleteScreen.visible = false

func win(rating: float = 1.0):
	%CompleteScreen.visible = true
	if randf() < 0.5:
		%CompleteHeader.text = "YOU WIN 10 WORMS!"
		Game.game.worms += 10
	else:
		%CompleteHeader.text = "YOU WIN 7 GOLD!"
		Game.game.gold += 7

func loose():
	%CompleteScreen.visible = true
	%CompleteHeader.text = "YOU SUCK!"


func _on_button_exit_pressed() -> void:
	Game.game.open_overworld()
