class_name Minigame
extends Node2D

signal finished(score: float)
signal score_changed(score:float)

@export var prompt := "do something epic"

var window: MinigameWindow

var score := 0.0 :
	set(v):
		score = v
		score_changed.emit(score)

# Override those if you want a custom behaviour.
func _finished():
	finished.emit(score)

func timer_ended():
	_finished()

func shake():
	window.shake()
