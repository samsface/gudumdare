class_name Minigame
extends Node2D

signal minigame_gameover_lost
signal minigame_gameover_won(rating: float)

@export var prompt := "do something epic"

var window: MinigameWindow

# Override those if you want a custom behaviour.
func win(rating: float = 1.0):
	minigame_gameover_won.emit(rating)
	Game.worms += ceil(rating * 3.0)

func loose():
	minigame_gameover_lost.emit()

func timer_ended():
	loose()

func shake():
	window.shake()
