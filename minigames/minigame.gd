class_name Minigame
extends Node2D

signal minigame_gameover_lost
signal minigame_gameover_won(rating: float)

# Override those if you want a custom behaviour.
func win(rating: float = 1.0):
	minigame_gameover_won.emit(rating)

func loose():
	minigame_gameover_lost.emit()

func timer_ended():
	loose()
