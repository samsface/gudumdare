extends Minigame

func _on_win_mouse_pressed() -> void:
	score = 1.0
	_finished()


func _on_loose_mouse_pressed() -> void:
	_finished()
